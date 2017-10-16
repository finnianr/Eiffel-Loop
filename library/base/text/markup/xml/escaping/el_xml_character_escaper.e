note
	description: "Summary description for {EL_XML_CHARACTER_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_XML_CHARACTER_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_CHARACTER_ESCAPER [S]
		redefine
			is_escaped
		end

create
	make, make_128_plus

feature {NONE} -- Initialization

	make
		do
			create predefined_entities.make (4)
			extend_entities ('<', "lt")
			extend_entities ('>', "gt")
			extend_entities ('&', "amp")
			extend_entities ('%'', "apos")

			create characters.make (predefined_entities.count)
			across predefined_entities as entity loop
				characters.append_code (entity.key)
			end
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
			entities.search (code)
			if entities.found then
				Result := entities.found_item
			else
				l_name := empty_once_string_8
				l_name.append_character ('#')
				l_name.append_natural_32 (code)
				Result := named_entity (l_name)
			end
		end

feature -- Element change

	extend_entities (uc: CHARACTER_32; name: STRING)
		do
			predefined_entities.extend (named_entity (name), uc.natural_32_code)
		end

	extend (uc: CHARACTER_32)
		do
			predefined_entities.extend (escape_sequence (uc.natural_32_code), uc.natural_32_code)
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: S; code: NATURAL)
		do
			str.append (escape_sequence (code))
		end

	is_escaped (a_characters: like characters; code: NATURAL): BOOLEAN
		do
			if escape_128_plus and then code > 128 then
				Result := True
			else
				Result := Precursor (a_characters, code)
			end
		end

	named_entity (a_name: STRING): STRING
		do
			create Result.make (a_name.count + 2)
			Result.append_character ('&')
			Result.append (a_name)
			Result.append_character (';')
		end

	predefined_entities: HASH_TABLE [STRING, NATURAL]

	escape_128_plus: BOOLEAN

	characters: STRING_32

end