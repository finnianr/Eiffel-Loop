note
	description: "Path to directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:06:56 GMT (Monday 14th February 2022)"
	revision: "3"

class
	EL_DIR_ZPATH

inherit
	EL_ZPATH

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

create
	default_create, make, make_from_steps, make_parent, make_from_tuple

create {EL_ZPATH} make_tokens

convert
	make ({IMMUTABLE_STRING_8, ZSTRING, STRING, STRING_32}),

	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL},
	to_obsolete: {DIR_PATH}

feature -- Access

	relative_path (a_parent: EL_DIR_ZPATH): EL_DIR_ZPATH
		do
			if a_parent.step_count <= step_count then
				create Result.make_tokens (step_count - a_parent.step_count)
				Result.append_subpath (Current, a_parent.step_count + 1)
			else
				create Result
			end
		end

feature -- Conversion

	to_obsolete: DIR_PATH
		do
			create Result.make (to_string)
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

	is_parent_of (other: EL_ZPATH): BOOLEAN
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

	plus alias "+" (path: EL_FILE_ZPATH): like Type_file_path
		do
			create Result.make_tokens (step_count + path.step_count - path.leading_backstep_count)
			Result.append (Current); Result.append_path (path)
		end

	plus_dir alias "#+" (a_dir_path: EL_DIR_ZPATH): like Current
		do
			Result := twin
			Result.append_path (a_dir_path)
		end

feature {NONE} -- Implementation

	new_path (n: INTEGER): like Current
		do
			create Result.make_tokens (n)
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

	temporary_joined_tuple (tuple: TUPLE): ZSTRING
		local
			i: INTEGER
		do
			Result := temporary_path
			from i := 1 until i > tuple.count loop
				if not Result.is_empty then
					Result.append_character (Separator)
				end
				if tuple.is_reference_item (i) then
					if attached {ZSTRING} tuple.reference_item (i) as zstr then
						Result.append (zstr)
					elseif attached {READABLE_STRING_GENERAL} tuple.reference_item (i) as general then
						Result.append_string_general (general)
					elseif attached {EL_PATH} tuple.reference_item (i) as path
						and then not path.is_absolute
					then
						path.append_to (Result)
					elseif attached {PATH} tuple.reference_item (i) as path
						and then not path.is_absolute
					then
						Result.append_string_general (path.name)
					end
				else
					Result.append_string_general (tuple.item (i).out)
				end
				i := i + 1
			end
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_ZPATH
		require
			never_called: False
		once
			create Result.make_tokens (0)
		end

end