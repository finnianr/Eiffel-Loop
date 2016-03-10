note
	description: "Summary description for {EL_XML_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-12 12:37:15 GMT (Sunday 12th January 2014)"
	revision: "5"

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

	EL_MODULE_STRING
		export
			{NONE} all
		end

	EL_MODULE_LOG
		export
			{NONE} all
		end

feature -- Measurement

	data_payload_character_count (xml_text: STRING): INTEGER
			-- approximate count of text between tags
		local
			end_tag_list: EL_OCCURRENCE_SUBSTRINGS
			data_from, data_to, i: INTEGER
			has_data: BOOLEAN
		do
--			log.enter ("data_payload_character_count")
			create end_tag_list.make (xml_text, "</")
			from end_tag_list.start until end_tag_list.after loop
				data_to := end_tag_list.interval.lower - 1
				data_from := xml_text.last_index_of ('>', data_to) + 1
				has_data := False
				from i := data_from until has_data or i > data_to loop
					has_data := not xml_text.item (i).is_space
					i := i + 1
				end
				if has_data then
					Result := Result + data_to - (i - 1) + 1
--					log.put_string_field (
--						xml_text.substring (data_to + 1, xml_text.index_of ('>', data_to)),
--						xml_text.substring (i - 1, data_to)
--					)
					log.put_new_line
				end
				end_tag_list.forth
			end
--			log.exit
		end

feature -- Access

	entity (a_code: NATURAL): ASTRING
		do
			Result := xml_escaper.escape_sequence (a_code.to_character_32)
		end


	header (a_version: REAL; a_encoding: STRING): ASTRING
		local
			f: FORMAT_DOUBLE
		do
			create f.make (3, 1)
			Result := Header_template #$ [f.formatted (a_version), a_encoding]
			Result.left_adjust
		end

feature -- Conversion

	escaped (a_string: ASTRING): ASTRING
			-- Escapes characters: < > & '
		do
			Result := a_string.escaped (Xml_escaper)
		end

	escaped_128_plus (a_string: ASTRING): ASTRING
			-- Escapes characters: < > & ' and all codes > 128
		do
			Result := a_string.escaped (Xml_128_plus_escaper)
		end

	escaped_attribute (value: ASTRING): ASTRING
			-- Escapes attribute value characters and double quotes
		do
			Result := value.escaped (Attribute_escaper)
		end

	escaped_attribute_128_plus (value: ASTRING): ASTRING
			-- Escapes attribute value characters and double quotes and all codes > 128
		do
			Result := value.escaped (Attribute_128_plus_escaper)
		end

feature {NONE} -- Implementation

	code (char: CHARACTER): NATURAL
		do
			Result := char.natural_32_code
		end

feature {NONE} -- Constants

	Header_template: ASTRING
		once
			Result := "[
				<?xml version="$S" encoding="$S"?>

			]"
		end

end
