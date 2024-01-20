note
	description: "${EL_EXPAT_XML_PARSER} for parsing XHTML staring with `<!DOCTYPE html>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	EL_EXPAT_XHTML_PARSER

inherit
	EL_EXPAT_XML_PARSER
		redefine
			parse_string_and_set_error
		end

	EL_MODULE_HTML

create
	make

feature {NONE} -- Implementation

	parse_string_and_set_error (a_data: STRING; is_final: BOOLEAN)
			-- parse `a_data' (which may be empty).
			-- set the error flags according to result.
			-- `is_final' signals end of data input.
		do
			if HTML.is_document (a_data) then
				Precursor (HTML.to_xml (a_data), is_final)
			else
				Precursor (a_data, is_final)
			end
		end

end