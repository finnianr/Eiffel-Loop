note
	description: "ASCII ${NATURAL_32} codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-03 13:29:38 GMT (Wednesday 3rd April 2024)"
	revision: "6"

expanded class
	EL_ASCII

inherit
	EL_EXPANDED_ROUTINES

feature -- Punctuation

	Doublequote: NATURAL = 34

	Singlequote: NATURAL = 39

feature -- Control

	Ctrl_j, Newline, Line_feed: NATURAL = 10

	Escape: NATURAL = 27

	Shift_out, SO: NATURAL = 14

	Shift_in, SI: NATURAL = 15

feature -- Symbol

	Ampersand: NATURAL = 38

	Dollar: NATURAL = 36

	Equals_sign: NATURAL = 61

feature -- Separator

	Blank, Space: NATURAL = 32

	Ctrl_i, Horizontal_tab, Tab, Tabulation: NATURAL = 9

	Start_of_text, STX: NATURAL = 2
		-- see also `End_of_text'

	End_of_text, ETX: NATURAL = 3
		-- see also `Start_of_text'

feature -- Numbers

	Zero: NATURAL = 48

end