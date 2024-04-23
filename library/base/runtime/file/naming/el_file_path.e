note
	description: "Path to a file"
	notes: "Short alias is **FILE_PATH**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-22 14:57:56 GMT (Monday 22nd April 2024)"
	revision: "40"

class
	EL_FILE_PATH

inherit
	EL_PATH

	EL_MODULE_FILE

create
	default_create, make, make_expanded, make_from_other, make_from_path, make_from_steps

-- Cannot use `to_general: {READABLE_STRING_GENERAL}' due to bug
-- in `{PLAIN_TEXT_FILE}.file_open' for non-ascii characters

convert
--	from
	make ({ZSTRING, STRING, STRING_32, IMMUTABLE_STRING_8, IMMUTABLE_STRING_32}),
	make_from_path ({PATH}),
--	to
	to_string: {EL_ZSTRING}, as_string_32: {READABLE_STRING_GENERAL, READABLE_STRING_32},
	steps: {EL_PATH_STEPS}, to_path: {PATH}, to_uri: {EL_URI}

feature -- Access

	modification_time: INTEGER
		do
			Result := File.modification_time (Current)
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

	type_alias: ZSTRING
		-- localized description
		do
			Result := Word.file
		end

feature -- Conversion

	to_ntfs_compatible (c: CHARACTER): like Current
		-- NT file system compatible path string using `c' to substitue invalid characters
		local
			ntfs: EL_NT_FILE_SYSTEM_ROUTINES
		do
			Result := ntfs.translated (Current, c)
		end

feature -- Status report

	Is_directory: BOOLEAN = False

	is_pattern: BOOLEAN
		-- `True' if base is a wildcard pattern
		do
			Result := base.starts_with_general ("*.") and base.count > 2
		end

feature {NONE} -- Implementation

	new_path (a_path: ZSTRING): like Current
		do
			create Result.make (a_path)
		end

end