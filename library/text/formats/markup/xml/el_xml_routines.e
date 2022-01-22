note
	description: "XML routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-22 9:48:18 GMT (Saturday 22nd January 2022)"
	revision: "17"

class
	EL_XML_ROUTINES

inherit
	EL_MARKUP_ROUTINES

	EL_XML_ZSTRING_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_FILE_SYSTEM

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

	document_text (enclosing_elements: EL_STRING_8_LIST; encoding_name, text: STRING): STRING
		local
			lines: EL_STRING_8_LIST
		do
			create lines.make (3 + enclosing_elements.count * 2)
			lines.extend (header (1.0, encoding_name))
			across enclosing_elements as element loop
				lines.extend (open_tag (element.item))
			end
			lines.extend (text)
			across enclosing_elements.new_cursor.reversed as element loop
				lines.extend (closed_tag (element.item))
			end
			Result := lines.joined_lines
		end

	encoding (file_path: FILE_PATH): EL_MARKUP_ENCODING
		do
			create Result.make_from_file (file_path)
		end

	entity (unicode: NATURAL): ZSTRING
		do
			Result := xml_escaper.escape_sequence (unicode)
		end

	header (a_version: REAL; encoding_name: STRING): STRING
		local
			f: FORMAT_DOUBLE
		do
			create f.make (3, 1)
			Result := Header_template #$ [f.formatted (a_version), encoding_name]
			Result.left_adjust
		end

	root_element_name (xml: READABLE_STRING_GENERAL): STRING
			--
		local
			left_bracket_index, i: INTEGER
		do
			left_bracket_index := xml.last_index_of ('<', xml.count)
			if left_bracket_index > 0 then
				create Result.make (xml.count - left_bracket_index - 3)
				i := left_bracket_index + 1
				if xml [i] = '/' then
					i := i + 1
				end
				from until i > xml.count or else not is_identifier (xml [i]) loop
					Result.append_character (xml [i].to_character_8)
					i := i + 1
				end
			else
				create Result.make_empty
			end
		end

feature -- Constants

	Non_breaking_space: STRING = "&#xA0;"

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

feature -- Basic operations

	append_attribute (name, value, element: ZSTRING)
		-- append `name' and `value' to element string as XML attribute
		do
			if value.count > 0 then
				element.append_character (' ')
				element.append (name)
				element.append_character ('=')
				element.append_character ('"')
				element.append (value)
				element.append_character ('"')
			end
		end

feature {NONE} -- Implementation

	code (char: CHARACTER): NATURAL
		do
			Result := char.natural_32_code
		end

	is_identifier (uc: CHARACTER_32): BOOLEAN
		do
			inspect uc
				when 'a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-' then
					Result := True
			else
			end
		end
end