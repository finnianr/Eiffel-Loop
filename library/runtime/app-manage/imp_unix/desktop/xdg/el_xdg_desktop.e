note
	description: "Parsed XDG desktop entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 9:54:05 GMT (Sunday 24th December 2023)"
	revision: "5"

class
	EL_XDG_DESKTOP

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as Snake_case_title
		end

	EL_SETTABLE_FROM_ZSTRING

	EL_FILE_OPEN_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (desktop_path: FILE_PATH)
		do
			make_default
			if desktop_path.exists then
				set_from_lines (open_lines (desktop_path, Utf_8), '=')
			end
		end

feature -- Access

	comment: ZSTRING

	exec: ZSTRING

	icon: FILE_PATH

	name: ZSTRING

	path: DIR_PATH

	terminal: BOOLEAN

	type: STRING

feature {NONE} -- Constants

	Snake_case_title: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Proper
		end
end