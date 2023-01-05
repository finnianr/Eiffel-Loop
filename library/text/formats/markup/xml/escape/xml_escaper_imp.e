note
	description: "XML string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 15:48:44 GMT (Thursday 5th January 2023)"
	revision: "17"

deferred class
	XML_ESCAPER_IMP [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER_IMP [S]
		redefine
			append_escape_sequence, is_escaped
		end

	XML_ESCAPE_ROUTINES

feature -- Access

	escape_sequence (code: NATURAL; escape_128_plus: BOOLEAN): STRING
		local
			unicode: NATURAL
		do
			unicode := to_unicode (code)
			if escape_128_plus and then unicode > 128 then
				Result := hexadecimal_entity (unicode, False)
			else
				Result := entity (unicode.to_character_8, False)
			end
		end

feature -- Basic operations

	append_escape_sequence (escaper: XML_ESCAPER [S]; str: S; code: NATURAL)
		do
			str.append (escape_sequence (code, escaper.escape_128_plus))
		end

	is_escaped (escaper: XML_ESCAPER [S]; code: NATURAL): BOOLEAN
		do
			if escaper.escape_128_plus and then to_unicode (code) > 128 then
				Result := True
			else
				Result := escaper.has_code (code)
			end
		end

end