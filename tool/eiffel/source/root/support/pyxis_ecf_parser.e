note
	description: "Pyxis ECF parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-02 12:46:28 GMT (Wednesday 2nd February 2022)"
	revision: "9"

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
			nvp_start, nvp_end: INTEGER; assignment: EL_ASSIGNMENT_ROUTINES
			xml_ns: STRING; eiffel_url, configuration_name_value: ZSTRING
		do
			nvp_start := line.substring_index (Configuration_ns, 1)
			if nvp_start > 0 then
				-- expand line
				nvp_end := line.index_of (';', nvp_start)
				if nvp_end = 0 then
					nvp_end := end_index
				else
					nvp_end := nvp_end - 1
				end
				configuration_name_value := line.substring (nvp_start, nvp_end)

				eiffel_url := Eiffel_configuration + assignment.value (configuration_name_value)
				xml_ns := XMS_NS_template #$ [eiffel_url, eiffel_url, eiffel_url]
				line.replace_substring (xml_ns, nvp_start, nvp_end)

				Precursor (line, start_index, end_index + (xml_ns.count - configuration_name_value.count))
			else
				Precursor (line, start_index, end_index)
			end
		end

feature {NONE} -- Constants

	Configuration_ns: STRING = "configuration_ns"

	Eiffel_configuration: ZSTRING
		once
			Result := "http://www.eiffel.com/developers/xml/configuration-"
		end

	XMS_NS_template: ZSTRING
		once
			Result := "[
				xmlns = "#"; xmlns.xsi = "http://www.w3.org/2001/XMLSchema-instance"; xsi.schemaLocation = "# #.xsd"
			]"
		end

end