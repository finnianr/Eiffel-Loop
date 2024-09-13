note
	description: "Path to a directory"
	notes: "[
		**Short Alias Name**
		
			DIR_PATH

		**Joining Paths**
		
		Note that the alias `#+' is used to join directories and using `+' results in a file path.
		Implicit string conversions are employed to create a `DIR_PATH' or `FILE_PATH' argument.
			
			local
				dir_path: DIR_PATH
				file_path: FILE_PATH
			do
				dir_path := "/home/john"
				dir_path := dir_path #+ "Desktop"
				file_path := dir_path + "myfile.doc"
			end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 19:02:15 GMT (Friday 13th September 2024)"
	revision: "46"

class
	EL_DIR_PATH

inherit
	EL_PATH
		export
			{EL_PATH_PARENT} temporary_path
		redefine
			has_step
		end

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

	EL_MODULE_TUPLE

create
	default_create, make, make_expanded, make_from_path, make_from_other, make_from_steps, make_parent

-- Cannot use `to_general: {READABLE_STRING_GENERAL}' due to bug
-- in `{PLAIN_TEXT_FILE}.file_open' for non-ascii characters

convert
--	from
	make ({IMMUTABLE_STRING_8, ZSTRING, STRING, STRING_32}), make_from_path ({PATH}),
--	to
	to_string: {ZSTRING}, as_string_32: {READABLE_STRING_GENERAL, READABLE_STRING_32},
	steps: {EL_PATH_STEPS}, to_path: {PATH}, to_uri: {EL_URI}

feature {NONE} -- Initialization

	make_parent (other: EL_PATH)
		-- make the parent path of `other' and avoid making a copy of `other.parent_path' if
		-- already existing in `Parent_set'
		local
			index, l_count: INTEGER
		do
			if other.has_parent then
				if attached Shared_key_path as key_path then
					key_path.share (other.parent_string (False))
					inspect key_path.count
						when 0, 1 then
							index := 0
					else
						index := key_path.last_index_of (Separator, key_path.count - 1)
					end
					inspect index
						when 0 then
							if key_path [1] = Separator then
							-- Eg: `other' is /etc
								create base.make_filled (Separator, 1)
							else
							-- Eg. `other' is C:/Users
								base := key_path.substring (1, key_path.count - 1)
							end
							set_parent_path (Empty_path)
					else
						l_count := key_path.count
					-- Avoids making a substring of `key_path' if found in set
						key_path.set_count (index) -- Must restore later
						Parent_set.put_copy (key_path) -- safe to make a twin
						parent_path := Parent_set.found_item
						key_path.set_count (l_count) -- restored

						base := key_path.substring (index + 1, key_path.count - 1)
					end
				end
			else
				default_create
			end
		ensure
			other_parent_string_unchanged: old other.parent_string (True) ~ other.parent_string (False)
			definition: plus_dir (other.base).to_string ~ other.to_string
		end

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

feature -- Conversion

	to_ntfs_compatible (c: CHARACTER): like Current
		-- NT file system compatible path string using `c' to substitue invalid characters
		local
			ntfs: EL_NT_FILE_SYSTEM_ROUTINES
		do
			Result := ntfs.translated_dir_path (Current, c)
		end

feature -- Aliased joins

	plus alias "+" (a_file_path: EL_FILE_PATH): like Type_file_path
		do
			create Result.make_from_other (Current); Result.append (a_file_path)
		end

	plus_dir alias "#+" (a_dir_path: EL_DIR_PATH): like Current
		do
			create Result.make_from_other (Current)
			Result.append_dir_path (a_dir_path)
		end

feature -- Path joining

	joined_dir_steps (a_steps: FINITE [READABLE_STRING_GENERAL]): like Current
		do
			create Result.make (temporary_joined (a_steps))
		end

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

feature -- Status report

	exists_and_is_writeable: BOOLEAN
		local
			dir: like Shared_directory
		do
			if is_empty then
				dir := Shared_directory.named_as_current
			else
				dir := Shared_directory.named (Current)
			end
			Result := dir.exists and then dir.is_writable
		end

	has_step (step: READABLE_STRING_GENERAL): BOOLEAN
			-- true if path has directory step
		do
			Result := base.same_string_general (step) or else Precursor (step)
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

	temporary_joined_tuple (a_tuple: TUPLE): ZSTRING
		do
			Result := temporary_path
			if a_tuple.count > 0 then
				Result.append_character (Separator)
			end
			Tuple.write (a_tuple, Result, Directory_separator)
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_PATH
		require
			never_called: False
		once
		end

feature -- Constants

	Is_directory: BOOLEAN = True

	Directory_separator: STRING
		once
			Result := Operating_environment.Directory_separator.out
		end

	Shared_key_path: ZSTRING
		once
			create Result.make_empty
		end

end