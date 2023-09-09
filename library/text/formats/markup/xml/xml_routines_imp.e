note
	description: "XML routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-09 14:19:20 GMT (Saturday 9th September 2023)"
	revision: "28"

class
	XML_ROUTINES_IMP

inherit
	EL_MARKUP_ROUTINES

	XML_ZSTRING_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_FILE_SYSTEM

feature -- Measurement

	data_payload_character_count (xml_text: ZSTRING): INTEGER
		-- approximate count of text between tags
		local
			data_from, data_to, i: INTEGER
			has_data: BOOLEAN
		do
			if attached xml_text.substring_intervals (Bracket.left_slash, False) as list then
				from list.start until list.after loop
					data_to := list.item_lower - 1
					data_from := xml_text.last_index_of ('>', data_to) + 1
					has_data := False
					from i := data_from until has_data or i > data_to loop
						has_data := not xml_text.is_space_item (i)
						i := i + 1
					end
					if has_data then
						Result := Result + data_to - (i - 1) + 1
					end
					list.forth
				end
			end
		end

feature -- Access

	document_text (doc_xpath, encoding_name, text: STRING): STRING
		-- create XML document with text enclosed by nested elements specified by `doc_xpath'
		-- Eg. "body", "html/body"
		local
			lines, enclosing_elements: EL_STRING_8_LIST
		do
			create enclosing_elements.make_split (doc_xpath, '/')
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

	entity (unicode: CHARACTER_32): ZSTRING
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

	root_element_name (a_xml: READABLE_STRING_GENERAL): STRING
			--
		local
			left_bracket_index, i: INTEGER
		do
			left_bracket_index := a_xml.last_index_of ('<', a_xml.count)
			if left_bracket_index > 0 then
				create Result.make (a_xml.count - left_bracket_index - 3)
				i := left_bracket_index + 1
				if a_xml [i] = '/' then
					i := i + 1
				end
				from until i > a_xml.count or else not is_identifier (a_xml [i].to_character_8) loop
					Result.append_character (a_xml [i].to_character_8)
					i := i + 1
				end
			else
				create Result.make_empty
			end
		end

feature -- Document status

	is_xml_declaration (text: READABLE_STRING_8): BOOLEAN
		do
			Result := text.count >= 5 and then text [2] = '?' and then text.same_caseless_characters (Xml, 1, 3, 3)
		end

	is_namespace_aware (a_xml: READABLE_STRING_8): BOOLEAN
		-- `True' if xmlns name exists in document root element
		local
			tag_splitter: EL_SPLIT_ON_CHARACTER_8 [READABLE_STRING_8]
			done: BOOLEAN
		do
			create tag_splitter.make (a_xml, '%N')
			across tag_splitter as split until done or Result loop
				if attached split.item as line then
					if has_xmlns_attribute (line) then
						Result := True

					elseif has_element_ending (line) then
						done := True
					end
				end
			end
		end

	is_namespace_aware_file (path: FILE_PATH): BOOLEAN
		-- `True' if xmlns name exists in document root element
		require
			path_exists: path.exists
		local
			file: PLAIN_TEXT_FILE; done: BOOLEAN
		do
			create file.make_with_name (path)
			if file.exists then
				from file.open_read until Result or done loop
					file.read_line
					if file.end_of_file then
						done := True

					elseif attached file.last_string as line then
						if has_xmlns_attribute (line) then
							Result := True

						elseif has_element_ending (line) then
							done := True

						end
					end
				end
				file.close
			end
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

feature -- Constants

	Default_doc: EL_DEFAULT_SERIALIZEABLE_XML
		-- <?xml version="1.0" encoding="UTF-8"?>
		-- <default/>
		once
			create Result
		end

	Non_breaking_space: STRING = "&#xA0;"

	XMLNS: STRING = "xmlns"

	Xml: STRING = "xml"

feature {NONE} -- Implementation

	code (char: CHARACTER): NATURAL
		do
			Result := char.natural_32_code
		end

	is_identifier (c: CHARACTER): BOOLEAN
		do
			inspect c
				when 'a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-' then
					Result := True
			else
			end
		end

	has_element_ending (str: READABLE_STRING_8): BOOLEAN
		-- `True' if `str' has right angle bracket and is not a comment
		-- or processing instruction
		local
			rbracket_index: INTEGER; c: CHARACTER
		do
			rbracket_index := str.index_of ('>', 1)
			if rbracket_index > 1 then
				c := str [rbracket_index - 1]
				inspect c
					when 'a' .. 'z', 'A' .. 'Z', '0' .. '9', '/', '"' then
						Result := True
				else
					Result := c.is_space
				end
			end
		end

	has_xmlns_attribute (str: READABLE_STRING_8): BOOLEAN
		local
			index_xml_ns: INTEGER
		do
			index_xml_ns := str.substring_index (XMLNS, 1)
			if index_xml_ns > 0 and then str.valid_index (index_xml_ns + XMLNS.count) then
				inspect str [index_xml_ns + XMLNS.count]
					when ' ', '=', ':' then
						Result := True
				else
				end
			end
		end

end