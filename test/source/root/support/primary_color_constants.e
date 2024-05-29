note
	description: "Primary color constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 12:48:51 GMT (Wednesday 29th May 2024)"
	revision: "1"

deferred class
	PRIMARY_COLOR_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Colors

	Blue: INTEGER = 2

	Green: INTEGER = 3

	Red: INTEGER = 1

feature {NONE} -- Constants

	Color_name_table: EL_IMMUTABLE_NAME_TABLE [INTEGER]
		once
			create Result.make (Valid_colors, Color_names)
		end

	Color_names: STRING = "Red, Blue, Green"

	Valid_colors: ARRAY [INTEGER]
		once
			Result := << Red, Blue, Green >>
		end

end