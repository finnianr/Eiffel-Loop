note
	description: "File path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 23:26:28 GMT (Sunday 23rd December 2018)"
	revision: "12"

class
	EL_FILE_PATH

inherit
	EL_PATH

create
	default_create, make, make_from_general, make_from_path, make_from_other

convert
	make ({ZSTRING}), make_from_general ({STRING_32, STRING}), make_from_path ({PATH}),

 	to_string: {EL_ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature -- Access

	modification_date_time: DATE_TIME
		do
			if exists then
				create Result.make_from_epoch (modification_time)
			else
				create Result.make (0, 0, 0, 0, 0, 0)
			end
		end

	modification_time: INTEGER
		do
			Result := File_system.file_modification_time (Current)
		end

	relative_dot_path (other: EL_FILE_PATH): EL_FILE_PATH
		-- relative path using dots do navigate from  `other.parent' to `base'
		-- Eg. ../../<base> OR ../bbb/<base> OR <base>
		local
			dot_dir, super_dir: EL_DIR_PATH
		do
			if parent ~ other.parent then
				Result := base

			elseif parent.is_parent_of (other) then
				create dot_dir.make (Directory.relative_parent (other.step_count - step_count))
				Result := dot_dir + base
			else
				from super_dir := parent until super_dir.is_parent_of (Current) and super_dir.is_parent_of (other) loop
					super_dir := super_dir.parent
				end
				create dot_dir.make (Directory.relative_parent (other.step_count - super_dir.step_count - 1))
				Result := dot_dir + relative_path (super_dir)
			end
		end

feature -- Status report

	Is_directory: BOOLEAN = False

	exists: BOOLEAN
		do
			Result := File_system.file_exists (Current)
		end

feature {NONE} -- Implementation

	new_relative_path: EL_FILE_PATH
		do
			create Result.make_from_other (Current)
		end

end
