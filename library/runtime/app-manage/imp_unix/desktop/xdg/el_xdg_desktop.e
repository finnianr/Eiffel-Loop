note
	description: "Parsed XDG desktop entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-11 12:29:19 GMT (Tuesday 11th April 2023)"
	revision: "1"

class
	EL_XDG_DESKTOP

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		end

	EL_SETTABLE_FROM_ZSTRING

	EL_FILE_OPEN_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (desktop_path: FILE_PATH)
		local
			str: ZSTRING; assignment: EL_ASSIGNMENT_ROUTINES
		do
			make_default
			across open_lines (desktop_path, Utf_8) as line loop
				str := line.item
				if attached assignment.name (str) as field_name and then field_name.is_code_identifier then
					field_name.to_lower
					set_field (field_name, assignment.value (str))
				end
			end
		end

feature -- Access

	comment: ZSTRING

	exec: ZSTRING

	icon: FILE_PATH

	name: ZSTRING

	terminal: BOOLEAN

	type: STRING

end