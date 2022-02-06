note
	description: "Path to a file"
	notes: "Alias is **FILE_PATH**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 17:51:43 GMT (Sunday 6th February 2022)"
	revision: "25"

class
	EL_FILE_PATH

inherit
	EL_PATH

	EL_MODULE_DATE_TIME

create
	default_create, make, make_from_path, make_from_other, make_from_steps

convert
	make ({ZSTRING, STRING, STRING_32, IMMUTABLE_STRING_8, IMMUTABLE_STRING_32}),
	make_from_path ({PATH}),

 	to_string: {EL_ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL},
 	steps: {EL_PATH_STEPS}, to_path: {PATH}, to_uri: {EL_URI}

feature -- Access

	modification_date_time: EL_DATE_TIME
		do
			if exists then
				create Result.make_from_epoch (modification_time)
			else
				create Result.make_from_other (Date_time.Origin)
			end
		end

	modification_time: INTEGER
		do
			Result := File_system.file_modification_time (Current)
		end

	relative_dot_path (other: FILE_PATH): FILE_PATH
		-- relative path using dots do navigate from  `other.parent' to `base'
		-- Eg. ../../<base> OR ../bbb/<base> OR <base>
		local
			dot_dir, super_dir: DIR_PATH
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

	relative_path (a_parent: DIR_PATH): FILE_PATH
		do
			create Result.make (relative_temporary_path (a_parent))
		end

feature -- Status report

	Is_directory: BOOLEAN = False

	is_pattern: BOOLEAN
		-- `True' if base is a wildcard pattern
		do
			Result := base.starts_with_general ("*.") and base.count > 2
		end

end