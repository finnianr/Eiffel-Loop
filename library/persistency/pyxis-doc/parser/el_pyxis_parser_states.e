note
	description: "Pyxis parser states"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-09 17:24:19 GMT (Saturday 9th January 2021)"
	revision: "1"

class
	EL_PYXIS_PARSER_STATES

feature {NONE} -- Constants

	State_find_pyxis_doc: NATURAL_8 = 1

	State_gather_element_attributes: NATURAL_8 = 2

	State_parse_line: NATURAL_8 = 3

	State_gather_verbatim_lines: NATURAL_8 = 4

	State_output_content_lines: NATURAL_8 = 5

	State_gather_comments: NATURAL_8 = 6

--	State_: NATURAL_8 = 1

--	State_: NATURAL_8 = 1

--	State_: NATURAL_8 = 1

--	State_: NATURAL_8 = 1

--	State_: NATURAL_8 = 1

--	State_: NATURAL_8 = 1
end