note
	description: "ASCII ${NATURAL_32} codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_ASCII

feature -- Punctuation

	Doublequote: NATURAL = 34

	Singlequote: NATURAL = 39

feature -- Control

	Ctrl_j, Newline, Line_feed: NATURAL = 10

	Escape: NATURAL = 27

feature -- Symbol

	Ampersand: NATURAL = 38

	Dollar: NATURAL = 36

	Equals_sign: NATURAL = 61

feature -- Separator

	Blank, Space: NATURAL = 32

	Ctrl_i, Horizontal_tab, Tab, Tabulation: NATURAL = 9

feature -- Numbers

	Zero: NATURAL = 48

end