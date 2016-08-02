note
	description: "Summary description for {EL_XML_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 7:05:47 GMT (Saturday 2nd July 2016)"
	revision: "1"

class
	EL_XML_ROUTINES

inherit
	EL_MARKUP_ROUTINES

	EL_XML_ESCAPING_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_FILE_SYSTEM
		export
			{NONE} all
		end

feature -- Measurement

	data_payload_character_count (xml_text: ZSTRING): INTEGER
			-- approximate count of text between tags
		local
			end_tag_list: EL_SEQUENTIAL_INTERVALS; data_from, data_to, i: INTEGER
			has_data: BOOLEAN
		do
			end_tag_list := xml_text.substring_intervals (Close_tag_marker)
			from end_tag_list.start until end_tag_list.after loop
				data_to := end_tag_list.item_lower - 1
				data_from := xml_text.last_index_of ('>', data_to) + 1
				has_data := False
				from i := data_from until has_data or i > data_to loop
					has_data := not xml_text.is_space_item (i)
					i := i + 1
				end
				if has_data then
					Result := Result + data_to - (i - 1) + 1
				end
				end_tag_list.forth
			end
		end

feature -- Access

	entity (unicode: NATURAL): ZSTRING
		do
			Result := xml_escaper.escape_sequence (unicode)
		end

	header (a_version: REAL; a_encoding: STRING): ZSTRING
		local
			f: FORMAT_DOUBLE
		do
			create f.make (3, 1)
			Result := Header_template #$ [f.formatted (a_version), a_encoding]
			Result.left_adjust
		end

feature -- Conversion

	escaped (a_string: ZSTRING): ZSTRING
			-- Escapes characters: < > & '
		do
			Result := a_string.escaped (Xml_escaper)
		end

	escaped_128_plus (a_string: ZSTRING): ZSTRING
			-- Escapes characters: < > & ' and all codes > 128
		do
			Result := a_string.escaped (Xml_128_plus_escaper)
		end

	escaped_attribute (value: ZSTRING): ZSTRING
			-- Escapes attribute value characters and double quotes
		do
			Result := value.escaped (Attribute_escaper)
		end

	escaped_attribute_128_plus (value: ZSTRING): ZSTRING
			-- Escapes attribute value characters and double quotes and all codes > 128
		do
			Result := value.escaped (Attribute_128_plus_escaper)
		end

feature {NONE} -- Implementation

	code (char: CHARACTER): NATURAL
		do
			Result := char.natural_32_code
		end

end