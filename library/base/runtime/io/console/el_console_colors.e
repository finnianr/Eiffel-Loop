note
	description: "ANSI escape sequence codes for foreground color"
	notes: "Accessible via ${EL_LOGGABLE_CONSTANTS}.Color"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 10:25:27 GMT (Thursday 4th April 2024)"
	revision: "6"

class
	EL_CONSOLE_COLORS

inherit
	ANY
		rename
			default as any_default
		end

feature -- Colors

	Black: INTEGER = 30

	Blue: INTEGER = 34

	Yellow: INTEGER = 33

	Cyan: INTEGER = 36

	Default: INTEGER = 0

	Green: INTEGER = 32

	Purple: INTEGER = 35

	Red: INTEGER = 31

	White: INTEGER = 37

feature -- Access

	name (color: INTEGER): STRING
		require
			valid_color: valid_colors.has (color)
		do
			inspect color
				when Black then
					Result := "Black"
				when Blue then
					Result := "Blue"
				when Yellow then
					Result := "Yellow"
				when Cyan then
					Result := "Cyan"
				when Default then
					Result := "Default"
				when Green then
					Result := "Green"
				when Purple then
					Result := "Purple"
				when Red then
					Result := "Red"
				when White then
					Result := "White"
			else
				Result := "Unknown"
			end
		end

	valid_colors: ARRAY [INTEGER]
		once
			Result := << Black, Blue, Yellow, Cyan, Default, Green, Purple, Red, White >>
		end
end