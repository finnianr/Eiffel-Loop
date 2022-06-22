note
	description: "Path to file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 18:00:35 GMT (Tuesday 15th February 2022)"
	revision: "5"

class
	EL_FILE_PATH

inherit
	EL_PATH

	EL_MODULE_DATE_TIME; EL_MODULE_FILE

create
	default_create, make, make_from_steps, make_parent, make_from_tuple, make_sub_path,
	make_from_path, make_steps

convert
	make_from_steps ({ARRAY [ZSTRING], ARRAY [STRING], ARRAY [STRING_32]}),

	make ({IMMUTABLE_STRING_8, ZSTRING, STRING, STRING_32}), make_from_path ({PATH}),

	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, to_path: {PATH},
	to_uri: {EL_URI}

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
			Result := File.modification_time (Current)
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
				from
					super_dir := parent
				until
					super_dir.is_parent_of (Current) and super_dir.is_parent_of (other)
				loop
					super_dir.remove_tail (1)
				end
				create dot_dir.make (Directory.relative_parent (other.step_count - super_dir.step_count - 1))
				Result := dot_dir + relative_path (super_dir)
			end
		end

	relative_path (a_parent: EL_DIR_PATH): EL_FILE_PATH
		do
			if a_parent.step_count <= step_count then
				create Result.make_steps (step_count - a_parent.step_count)
				Result.append_subpath (Current, a_parent.step_count + 1)
			else
				create Result
			end
		end

feature -- Status report

	Is_directory: BOOLEAN = False

	is_pattern: BOOLEAN
		-- `True' if base is a wildcard pattern
		do
			if attached internal_base as l_base then
				Result := l_base.starts_with_general ("*.") and l_base.count > 2
			end
		end

feature {NONE} -- Implementation

	new_path (n: INTEGER): like Current
		do
			create Result.make_steps (n)
		end
end