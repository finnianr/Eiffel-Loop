note
	description: "Unix implementation of [$source EL_OS_RELEASE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 9:29:34 GMT (Thursday 7th May 2020)"
	revision: "5"

class
	EL_OS_RELEASE_IMP

inherit
	EL_OS_RELEASE_I

	EL_OS_IMPLEMENTATION

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
		local
			list: EL_SPLIT_ZSTRING_LIST
		do
			if line.starts_with (Version_field) then
				create list.make (field_value (Version_field, line), ".")
				from list.start until list.after loop
					inspect list.index
						when 1 then
							major_version := list.integer_item
						when 2 then
							minor_version := list.integer_item
					else
						list.finish
					end
					list.forth
				end
				state := final
			end
		end

feature {NONE} -- Implementation

	field_value (field_id, line: ZSTRING): ZSTRING
		do
			Result := line.substring_end (field_id.count + 1)
			if Result.has_quotes (2) then
				Result.remove_quotes
			end
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
