note
	description: "Unix implementation of ${EL_OS_RELEASE_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 8:08:16 GMT (Monday 31st March 2025)"
	revision: "13"

class
	EL_OS_RELEASE_IMP

inherit
	EL_OS_RELEASE_I

	EL_UNIX_IMPLEMENTATION

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		local
			source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			Precursor
			name := Empty_string
			create source.make_utf_8 ("/etc/os-release")
			do_once_with_file_lines (agent find_name, source)
		end

feature -- Access

	major_version: INTEGER

	minor_version: INTEGER

	name: ZSTRING

feature {NONE} -- Line states

	find_name (line: ZSTRING)
		do
			if line.starts_with (Name_field) then
				name := field_value (Name_field, line)
				state := agent find_version
			end
		end

	find_version (line: ZSTRING)
		do
			if line.starts_with (Version_field) then
				across field_value (Version_field, line).split ('.') as list loop
					inspect list.cursor_index
						when 1 then
							major_version := list.item.to_integer
						when 2 then
							minor_version := list.item.to_integer
					else
					end
				end
				state := final
			end
		end

feature {NONE} -- Implementation

	field_value (field_id, line: ZSTRING): ZSTRING
		do
			Result := line.substring_end (field_id.count + 1)
			Result.remove_double
		end

feature {NONE} -- Constants

	Name_field: ZSTRING
		once
			Result := "NAME="
		end

	Version_field: ZSTRING
		once
			Result := "VERSION="
		end

end