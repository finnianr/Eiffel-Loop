note
	description: "ASCII [$source NATURAL_32] codes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 10:33:22 GMT (Thursday 1st December 2022)"
	revision: "1"

class
	EL_ASCII

feature -- Punctuation

	Doublequote: NATURAL = 34

	Singlequote: NATURAL = 39

feature -- Control

	Ctrl_j, Newline, Line_feed: NATURAL = 10

feature -- Symbol

	Dollar: NATURAL = 36

feature -- Separator

	Blank, Space: NATURAL = 32

	Ctrl_i, Horizontal_tab, Tab, Tabulation: NATURAL = 9

feature -- Numbers

	Zero: NATURAL = 48

end