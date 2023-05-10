note
	description: "GVFS command to read file properties"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-10 6:29:27 GMT (Wednesday 10th May 2023)"
	revision: "9"

class
	EL_GVFS_FILE_INFO_COMMAND

inherit
	EL_GVFS_URI_COMMAND
		rename
			eiffel_naming as kebab_case_lower
		redefine
			kebab_case_lower, ignore, find_line, reset
		end

	EL_SETTABLE_FROM_ZSTRING

create
	make

feature -- Access

	file_exists: BOOLEAN

	file_type: NATURAL_8

	file_content_type: STRING

	file_modified: INTEGER

	file_size: INTEGER

	info: TUPLE [exists: BOOLEAN; type: NATURAL_8; content_type: STRING; modified, size: INTEGER]
		do
			Result := [file_exists, file_type, file_content_type, file_modified, file_size]
		end

feature {NONE} -- Line states

	find_line (line: ZSTRING)
		local
			found: BOOLEAN
		do
			file_exists := True
			line.left_adjust
			across Field_prefix_list as list until found loop
				if line.starts_with (list.item) then
					line.replace_substring (File_prefix, 1, list.item.count)
					set_field_from_line (line, ':')
					found := True
				end
			end
		end

feature {NONE} -- Implementation

	ignore (a_error: ZSTRING): BOOLEAN
		do
			Result := is_file_not_found (a_error)
		end

	reset
		do
			file_exists := False
		end

feature {NONE} -- Constants

	Template: STRING = "gvfs-info $uri"

	Field_prefix_list: EL_ZSTRING_LIST
		once
			Result := "standard::, time::"
		end

	File_prefix: ZSTRING
		once
			Result := "file-"
		end

	Kebab_case_lower: EL_NAME_TRANSLATER
		once
			Result := kebab_case_translater (Case.lower)
		end

end