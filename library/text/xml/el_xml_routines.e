note
	description: "Summary description for {EL_XML_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:03 GMT (Monday 22nd July 2013)"
	revision: "4"

class
	EL_XML_ROUTINES

inherit
	EL_MODULE_FILE_SYSTEM
		redefine
			default_create
		end

	EL_MODULE_STRING
		undefine
			default_create
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			create Output_buffer.make_empty
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

	entity, escape_sequence (a_code: NATURAL): EL_ASTRING
		do
			Predefined_entities.search (a_code)
			if Predefined_entities.found then
				Result := Predefined_entities.found_item
			else
				Result := named_entity (once "#" + a_code.out)
			end
		end

	named_entity (a_name: READABLE_STRING_GENERAL): EL_ASTRING
		do
			create Result.make_from_unicode (once "&" + a_name + once ";")
		end

feature -- Mark up

	open_tag (name: READABLE_STRING_GENERAL): EL_ASTRING
			-- open tag markup
		do
			create Result.make_from_unicode (once "<" + name + once ">")
		end

	closed_tag (name: READABLE_STRING_GENERAL): EL_ASTRING
			-- closed tag markup
		do
			create Result.make_from_unicode (once "</" + name + once ">")
		end

	empty_tag (name: READABLE_STRING_GENERAL): EL_ASTRING
			-- empty tag markup
		do
			create Result.make_from_unicode (once "<" + name + once "/>")
		end

	value_element_markup (name, value: READABLE_STRING_GENERAL): EL_ASTRING
			-- Enclose a value inside matching element tags
		do
			create Result.make (name.count + value.count + 6)
			Result.append_string_general (open_tag (name))
			Result.append_string_general (value)
			Result.append_string_general (closed_tag (name))
			Result.append_character ('%N')
		end

	parent_element_markup (name, element_list: READABLE_STRING_GENERAL): EL_ASTRING
			-- Wrap a list of elements with a parent element
		do
			create Result.make (name.count + element_list.count + 7)
			Result.append_string_general (open_tag (name))
			Result.append_character ('%N')
			Result.append_string_general (element_list)
			Result.append_string_general (closed_tag (name))
			Result.append_character ('%N')
		end

	header (a_version: REAL; a_encoding: STRING): EL_ASTRING
		local
			f: FORMAT_DOUBLE
		do
			create f.make (3, 1)
			Result := Header_template.substituted (<< f.formatted (a_version), a_encoding >>)
			Result.left_adjust
		end

feature -- Conversion

	basic_escaped (a_string: EL_ASTRING): EL_ASTRING
			-- Escapes characters: < > & '
		do
			Result := internal_escaped (a_string, Predefined_entities_sans_quote, True)
		end

	basic_escaped_and_double_quotes (a_string: EL_ASTRING): EL_ASTRING
			-- Escapes characters: < > & ' "
		do
			Result := internal_escaped (a_string, Predefined_entities, True)
		end

	escaped (a_string: EL_ASTRING): EL_ASTRING
			-- Escapes characters: < > & '
			-- and all codes > 128
		do
			Result := internal_escaped (a_string, Predefined_entities_sans_quote, False)
		end

	escaped_and_double_quotes (a_string: EL_ASTRING): EL_ASTRING
			-- Escapes characters: < > & ' "
			-- and all codes > 128
		do
			Result := internal_escaped (a_string, Predefined_entities, False)
		end

feature {NONE} -- Implementation

	internal_escaped (a_string: EL_ASTRING; code_map: like Predefined_entities_sans_quote; basic_escape: BOOLEAN): EL_ASTRING
			--
		local
			i: INTEGER
			l_code: NATURAL
			buffer: like Output_buffer
			l_unicode: STRING_32
		do
			buffer := Output_buffer
			buffer.wipe_out
			buffer.grow (a_string.count)
			l_unicode := a_string.to_unicode

			from i := 1 until i > l_unicode.count loop
				l_code := l_unicode.code (i)
				if basic_escape then
					code_map.search (l_code)
					if code_map.found then
						buffer.append_string_general (code_map.found_item)
					else
						buffer.append_code (l_code)
					end
				elseif l_code > 128 then
					buffer.append_string_general (escape_sequence (l_code))
				end
				i := i + 1
			end
			create Result.make_from_unicode (buffer)
		end

	code (char: CHARACTER): NATURAL
		do
			Result := char.natural_32_code
		end

	Output_buffer: STRING_32

feature {NONE} -- Constants

	Predefined_entities_sans_quote: EL_HASH_TABLE [EL_ASTRING, NATURAL]
		once
			create Result.make_with_count (5)
			Result.merge (Predefined_entities)
			Result.remove (('"').natural_32_code)
		end

	Predefined_entities: EL_HASH_TABLE [EL_ASTRING, NATURAL]
		once
			create Result.make (<<
				[('<').natural_32_code, named_entity ("lt")],
				[('>').natural_32_code, named_entity ("gt")],
				[('&').natural_32_code, named_entity ("amp")],
				[('"').natural_32_code, named_entity ("quot")],
				[('%'').natural_32_code, named_entity ("apos")]
			>>)
		end

	Header_template: EL_TEMPLATE_STRING
		once
			create Result.make_from_latin1 ("[
				<?xml version="$S" encoding="$S"?>

			]")
		end

end
