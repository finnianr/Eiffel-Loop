note
	description: "Xml general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "5"

deferred class
	EL_XML_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		redefine
			append_escape_sequence, is_escaped
		end

	EL_SHARED_ONCE_STRINGS

feature {NONE} -- Initialization

	make
		do
			create predefined_entities.make (4)
			extend_entities ('<', "lt")
			extend_entities ('>', "gt")
			extend_entities ('&', "amp")
			extend_entities ('%'', "apos")

			make_escaper (new_predefined_string)
		end

	make_128_plus
			-- include escaping of all codes > 128
		do
			make; escape_128_plus := True
		end

feature -- Transformation

	escape_sequence (code: NATURAL): STRING
		local
			entities: like predefined_entities; l_name: STRING
		do
			entities := predefined_entities
			if entities.has_key (code) then
				Result := entities.found_item
			else
				l_name := empty_once_string_8
				l_name.append_character ('#')
				l_name.append_natural_32 (code)
				Result := named_entity (l_name)
			end
		end

feature -- Element change

	extend (uc: CHARACTER_32)
		do
			predefined_entities.extend (escape_sequence (uc.natural_32_code), uc.natural_32_code)
		end

	extend_entities (uc: CHARACTER_32; name: STRING)
		do
			predefined_entities.extend (named_entity (name), uc.natural_32_code)
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: like once_buffer; code: NATURAL)
		do
			str.append (escape_sequence (code))
		end

	is_escaped (table: like code_table; code: NATURAL): BOOLEAN
		do
			Result := table.found or else (escape_128_plus and then code > 128)
		end

	named_entity (a_name: STRING): STRING
		do
			create Result.make (a_name.count + 2)
			Result.append_character ('&')
			Result.append (a_name)
			Result.append_character (';')
		end

	new_predefined_string: STRING
		do
			create Result.make (predefined_entities.count)
			across predefined_entities as entity loop
				Result.append_code (entity.key)
			end
		end

feature {NONE} -- Internal attributes

	escape_128_plus: BOOLEAN

	predefined_entities: HASH_TABLE [STRING, NATURAL]

end
