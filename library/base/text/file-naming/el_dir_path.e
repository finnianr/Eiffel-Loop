note
	description: "Directory path name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-11 18:13:18 GMT (Wednesday 11th September 2019)"
	revision: "10"

class
	EL_DIR_PATH

inherit
	EL_PATH
		redefine
			has_step
		end

	EL_SHARED_DIRECTORY
		rename
			directory as shared_directory
		end

create
	default_create, make, make_from_path, make_from_other, make_from_steps

convert
	make ({ZSTRING, STRING_32, STRING}), make_from_path ({PATH}),

 	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature -- Conversion

	joined_dir_path (a_dir_path: EL_DIR_PATH): like Current
		do
			create Result.make_from_other (Current)
			Result.append_dir_path (a_dir_path)
		end

	joined_dir_steps (a_steps: FINITE [READABLE_STRING_GENERAL]): like Current
		do
			Result := joined_dir_path (create {EL_DIR_PATH}.make_from_steps (a_steps))
		end

	joined_dir_tuple (tuple: TUPLE): like Current
		do
			Result := joined_dir_steps (create {EL_ZSTRING_LIST}.make_from_tuple (tuple))
		end

	joined_file_path alias "+" (a_file_path: EL_FILE_PATH): like Type_file_path
		do
			create Result.make_from_other (Current); Result.append (a_file_path)
		end

	joined_file_steps (a_steps: FINITE [READABLE_STRING_GENERAL]): like joined_file_path
		do
			Result := joined_file_path (create {EL_FILE_PATH}.make_from_steps (a_steps))
		end

	joined_file_tuple (tuple: TUPLE): like joined_file_path
		do
			Result := joined_file_steps (create {EL_ZSTRING_LIST}.make_from_tuple (tuple))
		end

feature -- Status report

	exists: BOOLEAN
		do
			Result := named_directory (Current).exists
		end

	exists_and_is_writeable: BOOLEAN
		local
			dir: like Shared_directory
		do
			if is_empty then
				dir := named_directory (".")
			else
				dir := named_directory (Current)
			end
			Result := dir.exists and then dir.is_writable
		end

	has_step (step: ZSTRING): BOOLEAN
			-- true if path has directory step
		do
			Result := base ~ step or else Precursor (step)
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
			Result := named_directory (Current).is_writable
		end

feature {NONE} -- Implementation

	new_relative_path: EL_DIR_PATH
		do
			create Result.make_from_other (Current)
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
