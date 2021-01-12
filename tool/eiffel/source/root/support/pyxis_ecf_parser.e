note
	description: "Pyxis ecf parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-12 11:20:04 GMT (Tuesday 12th January 2021)"
	revision: "5"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			parse_from_file
		end

create
	make

feature {NONE} -- Implementation

	parse_from_file (file: PLAIN_TEXT_FILE)
		-- expand namespace shorthand:
		-- configuration_ns = "x-x-x"
		local
			ns_lines: EL_STRING_8_LIST; last_quote_pos, first_quote_pos, semi_colon_pos: INTEGER
			str, eiffel_url, attributes: STRING; xml_ns: ZSTRING
		do
			reset
			from until file.end_of_file loop
				file.read_line
				str := file.last_string
				if str.starts_with (Configuration_ns) then
					semi_colon_pos := str.index_of (';', 1)
					if semi_colon_pos > 0 then
						attributes := str.substring (semi_colon_pos + 1, str.count)
						attributes.left_adjust
						str := str.substring (1, semi_colon_pos - 1)
					else
						create attributes.make_empty
					end
					last_quote_pos := str.last_index_of ('"', str.count)
					first_quote_pos := str.last_index_of ('"', last_quote_pos - 1)
					eiffel_url := Eiffel_configuration + str.substring (first_quote_pos + 1, last_quote_pos - 1)
					xml_ns := Xml_ns_template #$ [eiffel_url, eiffel_url, eiffel_url]
					create ns_lines.make_with_lines (xml_ns.to_latin_1)
					if not attributes.is_empty then
						ns_lines.extend (attributes)
					end
					ns_lines.indent (1)
					ns_lines.do_all (agent call_state_procedure)
				else
					call_state_procedure (str)
				end
			end
			parse_final
		end

feature {NONE} -- Constants

	Configuration_ns: STRING
		once
			Result := "%Tconfiguration_ns"
		end

	Eiffel_configuration: STRING
		once
			Result := "http://www.eiffel.com/developers/xml/configuration-"
		end

	Xml_ns_template: ZSTRING
		once
			Result := "[
				xmlns = "#"
				xmlns.xsi = "http://www.w3.org/2001/XMLSchema-instance" 
				xsi.schemaLocation = "# #.xsd"
			]"
		end

end