note
	description: "XML general string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-17 9:48:21 GMT (Friday 17th July 2020)"
	revision: "12"

deferred class
	EL_XML_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		redefine
			append_escape_sequence, is_escaped
		end

	EL_XML_ESCAPE_ROUTINES

feature {NONE} -- Initialization

	make
		do
			make_escaper (Basic_entities)
		end

	make_128_plus
			-- include escaping of all codes > 128
		do
			make; escape_128_plus := True
		end

feature -- Access

	escape_sequence (code: NATURAL): STRING
		do
			if escape_128_plus and then code > 128 then
				Result := hexadecimal_entity (code, False)
			else
				Result := entity (code.to_character_8, False)
			end
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: like once_buffer; code: NATURAL)
		do
			str.append (escape_sequence (code))
		end

	is_escaped (code: NATURAL): BOOLEAN
		do
			if escape_128_plus and then code > 128 then
				Result := True
			else
				Result := code_table.has_key (code)
			end
		end

feature {NONE} -- Internal attributes

	escape_128_plus: BOOLEAN

feature {NONE} -- Constants

	Basic_entities: STRING = "<>&'%""

end
