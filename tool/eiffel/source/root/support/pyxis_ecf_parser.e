note
	description: "Pyxis ECF parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-01 16:55:17 GMT (Tuesday 1st February 2022)"
	revision: "8"

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
			ns_section: STRING; last_quote_pos, first_quote_pos, nvp_start, nvp_end: INTEGER
			eiffel_url, xml_ns, configuration_name_value, value: STRING
		do
			nvp_start := line.substring_index (Configuration_ns, 1)
			if nvp_start > 0 then
				-- expand line
				nvp_end := line.index_of (';', nvp_start)
				if nvp_end = 0 then
					nvp_end := line.count
				end
				configuration_name_value := line.substring (nvp_start, nvp_end)

				last_quote_pos := configuration_name_value.last_index_of ('"', configuration_name_value.count)
				first_quote_pos := configuration_name_value.index_of ('"', Configuration_ns.count)
				value := configuration_name_value.substring (first_quote_pos + 1, last_quote_pos - 1)

				eiffel_url := Eiffel_configuration + value
				xml_ns := XMS_NS_template #$ [eiffel_url, eiffel_url, eiffel_url]
				if nvp_end < line.count then
					xml_ns.append_character (';')
				end
				line.replace_substring (xml_ns, nvp_start, nvp_end)

				Precursor (line, start_index, end_index + (xml_ns.count - configuration_name_value.count))
			else
				Precursor (line, start_index, end_index)
			end
		end

feature {NONE} -- Constants

	Configuration_ns: STRING = "configuration_ns"

	Eiffel_configuration: STRING = "http://www.eiffel.com/developers/xml/configuration-"

	XMS_NS_template: ZSTRING
		once
			Result := "[
				xmlns = "#"; xmlns.xsi = "http://www.w3.org/2001/XMLSchema-instance"; xsi.schemaLocation = "# #.xsd"
			]"
		end

end