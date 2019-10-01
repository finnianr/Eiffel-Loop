note
	description: "Xml general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 15:28:38 GMT (Tuesday   1st   October   2019)"
	revision: "9"

deferred class
	EL_XML_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		redefine
			append_escape_sequence, is_escaped
		end

	EL_SHARED_ONCE_ZSTRING

feature {NONE} -- Initialization

	make
		do
			create predefined_entities.make (4, agent new_sequence)
			extend_entities ('<', "lt")
			extend_entities ('>', "gt")
			extend_entities ('&', "amp")
			extend_entities ('%'', "apos")
			extend_entities ('"', "quot")

			make_escaper (new_predefined_string)
		end

	make_128_plus
			-- include escaping of all codes > 128
		do
			make; escape_128_plus := True
		end

feature -- Transformation

	escape_sequence (code: NATURAL): like new_string
		do
			Result := predefined_entities.item (code)
		end

	append_escape_sequence (str: like new_string; code: NATURAL)
		do
			str.append (escape_sequence (code))
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

	hex_byte_count (code: NATURAL): INTEGER
		local
			mask: NATURAL
		do
			Result := 8
			mask := 0xF
			mask := mask |<< (32 - 4)
			from until mask = 0 or else (code & mask).to_boolean loop
				mask := mask |>> 4
				Result := Result - 1
			end
		end

	is_escaped (table: like code_table; code: NATURAL): BOOLEAN
		do
			Result := table.found or else (escape_128_plus and then code > 128)
		end

	named_entity (a_name: STRING): like new_string
		do
			Result := new_string (a_name.count + 2)
			Result.append_code (('&').natural_32_code)
			Result.append (a_name)
			Result.append_code ((';').natural_32_code)
		end

	new_sequence (code: NATURAL): like new_string
		local
			byte_count: INTEGER
		do
			byte_count := hex_byte_count (code)
			Result := new_string (4 + byte_count)
			Result.append (once "&#x")
			Result.append_substring (code.to_hex_string, 8 - byte_count + 1, 8)
			Result.append_code ((';').natural_32_code)
		end

	new_predefined_string: STRING
		do
			create Result.make (predefined_entities.count)
			across predefined_entities as entity loop
				Result.append_code (entity.key)
			end
		end

	new_string (n: INTEGER): STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	escape_128_plus: BOOLEAN

	predefined_entities: EL_CACHE_TABLE [like new_string, NATURAL]

end
