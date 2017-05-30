note
	description: "Summary description for {EL_PYXIS_ECF_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-28 17:18:54 GMT (Sunday 28th May 2017)"
	revision: "2"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			do_with_lines
		end

create
	make

feature {NONE} -- Implementation

	do_with_lines (initial: like state; sequence: LINEAR [ZSTRING])
		-- expand namespace shorthand:
		-- configuration_ns = "x-x-x"
		local
			lines, ns_lines: EL_ZSTRING_LIST; last_quote_pos, first_quote_pos, semi_colon_pos: INTEGER
			str, eiffel_url, attributes: ZSTRING
		do
			create lines.make (50)
			from sequence.start until sequence.after loop
				str := sequence.item
				if str.starts_with (Configuration_ns) then
					semi_colon_pos := str.index_of (';', 1)
					if semi_colon_pos > 0 then
						attributes := str.substring_end (semi_colon_pos + 1)
						attributes.left_adjust
						str := str.substring (1, semi_colon_pos - 1)
					else
						create attributes.make_empty
					end
					last_quote_pos := str.last_index_of ('"', str.count)
					first_quote_pos := str.last_index_of ('"', last_quote_pos - 1)
					eiffel_url := Eiffel_configuration + str.substring (first_quote_pos + 1, last_quote_pos - 1)
					create ns_lines.make_with_lines (Xml_ns_template #$ [eiffel_url, eiffel_url, eiffel_url])
					if not attributes.is_empty then
						ns_lines.extend (attributes)
					end
					ns_lines.indent (1)
					lines.append (ns_lines)
				else
					lines.extend (str)
				end
				sequence.forth
			end
			Precursor (initial, lines)
		end

feature {NONE} -- Constants

	Configuration_ns: ZSTRING
		once
			Result := "%Tconfiguration_ns"
		end

	Eiffel_configuration: ZSTRING
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
