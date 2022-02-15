note
	description: "Path to directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 18:00:51 GMT (Tuesday 15th February 2022)"
	revision: "5"

class
	EL_DIR_PATH

inherit
	EL_PATH

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

create
	default_create, make, make_from_steps, make_parent, make_from_tuple, make_sub_path,
	make_from_path, make_steps

convert
	make_from_steps ({ARRAY [ZSTRING], ARRAY [STRING], ARRAY [STRING_32]}),

	make ({IMMUTABLE_STRING_8, ZSTRING, STRING, STRING_32}), make_from_path ({PATH}),

	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, to_path: {PATH},
	to_uri: {EL_URI}

feature -- Access

	relative_path (a_parent: EL_DIR_PATH): EL_DIR_PATH
		do
			if a_parent.step_count <= step_count then
				create Result.make_steps (step_count - a_parent.step_count)
				Result.append_subpath (Current, a_parent.step_count + 1)
			else
				create Result
			end
		end

feature -- Status report

	exists_and_is_writeable: BOOLEAN
		local
			dir: like Shared_directory; s: EL_STRING_8_ROUTINES
		do
			if is_empty then
				dir := Shared_directory.named (s.character_string ('.'))
			else
				dir := Shared_directory.named (Current)
			end
			Result := dir.exists and then dir.is_writable
		end

	is_createable: BOOLEAN
			-- True if steps are createable as a directory
		local
			token: INTEGER
		do
			if is_absolute then
				if step_count > 1 then
					token := base_token
					area.remove_tail (1)
					Result := exists_and_is_writeable
					area.extend (token)
				end
			else
				Result := Directory.current_working.exists_and_is_writeable
			end
		end

	is_parent_of (other: EL_PATH): BOOLEAN
		-- `True' is `Current' directory is parent of `other'
		local
			i: INTEGER
		do
			if step_count < other.step_count then
				Result := True
				from i := 1 until not Result or i > step_count loop
					Result := i_th (i) = other.i_th (i)
					i := i + 1
				end
			end
		end

	Is_directory: BOOLEAN = True

	is_writable: BOOLEAN
		do
			Result := Shared_directory.named (Current).is_writable
		end

feature -- Aliased joins

	plus alias "+" (path: EL_FILE_PATH): like Type_file_path
		do
			create Result.make_steps (step_count + path.step_count - path.leading_backstep_count)
			Result.append (Current); Result.append_path (path)
		end

	plus_dir alias "#+" (path: EL_DIR_PATH): like Current
		do
			create Result.make_steps (step_count + path.step_count - path.leading_backstep_count)
			Result.append (Current); Result.append_path (path)
		end

feature -- Path joining

	joined_dir_tuple (a_tuple: TUPLE): like Current
		do
			create Result.make (temporary_joined_tuple (a_tuple))
		end

	joined_file_steps (a_steps: FINITE [READABLE_STRING_GENERAL]): like Type_file_path
		do
			create Result.make (temporary_joined (a_steps))
		end

	joined_file_tuple (a_tuple: TUPLE): like Type_file_path
		do
			create Result.make (temporary_joined_tuple (a_tuple))
		end

feature {NONE} -- Implementation

	new_path (n: INTEGER): like Current
		do
			create Result.make_steps (n)
		end

	temporary_joined (a_steps: FINITE [READABLE_STRING_GENERAL]): ZSTRING
		local
			list: LINEAR [READABLE_STRING_GENERAL]
		do
			Result := temporary_path
			list := a_steps.linear_representation
			from list.start until list.after loop
				if not Result.is_empty then
					Result.append_character (Separator)
				end
				Result.append_string_general (list.item)
				list.forth
			end
		end

	temporary_joined_tuple (a_tuple: TUPLE): ZSTRING
		require
			no_absolute_paths:
				across a_tuple as list all
					attached {EL_PATH} list.item as path implies not path.is_absolute
				end
		local
			i: INTEGER
		do
			Result := temporary_path
			from i := 1 until i > a_tuple.count loop
				if not Result.is_empty then
					Result.append_character (Separator)
				end
				Result.append_tuple_item (a_tuple, i)
				i := i + 1
			end
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_PATH
		require
			never_called: False
		once
			create Result
		end

end