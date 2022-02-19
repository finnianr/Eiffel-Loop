note
	description: "Path to a directory"
	notes: "[
		**Alias Name**
		
			EL_DIR_PATH

		**Joining Paths**
		
		Note that the alias `#+' is used to join directories and using `+' results in a file path.
		Implicit string conversions are employed to create a `EL_DIR_PATH' or `EL_FILE_PATH' argument.
			
			local
				dir_path: EL_DIR_PATH
				file_path: EL_FILE_PATH
			do
				dir_path := "/home/john"
				dir_path := dir_path #+ "Desktop"
				file_path := dir_path + "myfile.doc"
			end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 11:38:35 GMT (Saturday 19th February 2022)"
	revision: "26"

class
	EL_DIR_PATH

inherit
	EL_PATH
		redefine
			has_step
		end

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

create
	default_create, make, make_from_path, make_from_other, make_from_steps

convert
	make ({IMMUTABLE_STRING_8, ZSTRING, STRING, STRING_32}), make_from_path ({PATH}),

 	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL},
 	steps: {EL_PATH_STEPS}, to_path: {PATH}, to_uri: {EL_URI}

feature -- Access

	relative_path (a_parent: EL_DIR_PATH): EL_DIR_PATH
		do
			create Result.make (relative_temporary_path (a_parent))
		end

	type_alias: ZSTRING
		-- localized description
		do
			Result := Word.directory
		end

feature -- Aliased joins

	hash_plus alias "#+" (a_dir_path: EL_DIR_PATH): like Current
		do
			create Result.make_from_other (Current)
			Result.append_dir_path (a_dir_path)
		end

	plus alias "+" (a_file_path: EL_FILE_PATH): like Type_file_path
		do
			create Result.make_from_other (Current); Result.append (a_file_path)
		end

feature -- Path joining

	joined_dir_steps (a_steps: FINITE [READABLE_STRING_GENERAL]): like Current
		do
			create Result.make (temporary_joined (a_steps))
		end

	joined_dir_tuple (tuple: TUPLE): like Current
		do
			create Result.make (temporary_joined_tuple (tuple))
		end

	joined_file_steps (a_steps: FINITE [READABLE_STRING_GENERAL]): like Type_file_path
		do
			create Result.make (temporary_joined (a_steps))
		end

	joined_file_tuple (tuple: TUPLE): like Type_file_path
		do
			create Result.make (temporary_joined_tuple (tuple))
		end

feature -- Status report

	exists_and_is_writeable: BOOLEAN
		local
			dir: like Shared_directory
		do
			if is_empty then
				dir := Shared_directory.named (".")
			else
				dir := Shared_directory.named (Current)
			end
			Result := dir.exists and then dir.is_writable
		end

	has_step (step: READABLE_STRING_GENERAL): BOOLEAN
			-- true if path has directory step
		do
			Result := base.same_string (step) or else Precursor (step)
		end

	is_createable: BOOLEAN
		do
			Result := parent.exists_and_is_writeable
		end

	is_parent_of (other: EL_PATH): BOOLEAN
		do
			if other.parent_path.starts_with (parent_path) then
				Result := other.parent_path.substring_index (base, parent_path.count + 1) = parent_path.count + 1
			end
		end

	is_writable: BOOLEAN
		do
			Result := Shared_directory.named (Current).is_writable
		end

feature {NONE} -- Implementation

	new_path (a_path: ZSTRING): like Current
		do
			create Result.make (a_path)
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
				if Result.count > 0 then
					Result.append_character (Separator)
				end
				Result.append_tuple_item (tuple, i)
				i := i + 1
			end
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_PATH
		require
			never_called: False
		once
		end

feature -- Constants

	Is_directory: BOOLEAN = True

end