note
	description: "Pyxis ECF parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-02 12:20:50 GMT (Sunday 2nd May 2021)"
	revision: "7"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			parse_line
		end

create
	make

feature {NONE} -- State procedures

	parse_line (line: STRING; start_index, end_index: INTEGER)
		local
			expanded_line: STRING; last_quote_pos, first_quote_pos, semi_colon_pos: INTEGER
			eiffel_url, xml_ns: STRING
		do
			if line.starts_with (Configuration_ns) then
				last_quote_pos := line.last_index_of ('"', line.count)
				first_quote_pos := line.last_index_of ('"', last_quote_pos - 1)
				eiffel_url := Eiffel_configuration + line.substring (first_quote_pos + 1, last_quote_pos - 1)
				xml_ns := XMS_NS_template #$ [eiffel_url, eiffel_url, eiffel_url]
				xml_ns.prepend_character ('%T')

				semi_colon_pos := line.index_of (';', start_index)
				if semi_colon_pos > 0 then
					expanded_line := xml_ns + line.substring (semi_colon_pos, end_index)
				else
					expanded_line := xml_ns
				end
				Precursor (expanded_line, start_index, expanded_line.count)
			else
				Precursor (line, start_index, end_index)
			end
		end

feature {NONE} -- Constants

	Configuration_ns: STRING = "%Tconfiguration_ns"

	Eiffel_configuration: STRING = "http://www.eiffel.com/developers/xml/configuration-"

	XMS_NS_template: ZSTRING
		once
			Result := "[
				xmlns = "#"; xmlns.xsi = "http://www.w3.org/2001/XMLSchema-instance"; xsi.schemaLocation = "# #.xsd"
			]"
		end

end