note
	description: "Pyxis parser Constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-12 11:15:49 GMT (Tuesday 12th January 2021)"
	revision: "3"

class
	EL_PYXIS_PARSER_CONSTANTS

feature {NONE} -- Parser states

	State_parse_line: NATURAL_8 = 1

	State_gather_verbatim_lines: NATURAL_8 = 2

	State_output_content_lines: NATURAL_8 = 3

	State_gather_comments: NATURAL_8 = 4

feature {NONE} -- Constants

	New_line_character: CHARACTER = '%N'

	Pyxis_doc: STRING = "pyxis-doc"

	Triple_quote: STRING = "[
		"""
	]"
end