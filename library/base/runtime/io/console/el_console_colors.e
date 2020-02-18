note
	description: "ANSI escape sequence codes for foreground color"
	notes: "Accessible via {[$source EL_SHARED_CONSOLE_COLORS]}.Color"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 17:48:46 GMT (Tuesday 18th February 2020)"
	revision: "1"

class
	EL_CONSOLE_COLORS

inherit
	ANY
		rename
			default as any_default
		end

feature -- Access

	Black: INTEGER = 30

	Blue: INTEGER = 34

	Brown: INTEGER = 33

	Cyan: INTEGER = 36

	Default: INTEGER = 0

	Green: INTEGER = 32

	Purple: INTEGER = 35

	Red: INTEGER = 31

	White: INTEGER = 37

	valid_colors: ARRAY [INTEGER]
		once
			Result := << Black, Blue, Brown, Cyan, Default, Green, Purple, Red, White >>
		end
end
