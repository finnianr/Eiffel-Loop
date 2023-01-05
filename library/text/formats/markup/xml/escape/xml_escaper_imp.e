note
	description: "XML string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 17:49:59 GMT (Wednesday 4th January 2023)"
	revision: "16"

deferred class
	XML_ESCAPER_IMP [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER_IMP [S]
		redefine
			append_escape_sequence, is_escaped
		end

	XML_ESCAPE_ROUTINES

feature -- Initialization

	set_escape_128_plus (yes: BOOLEAN)
			-- include escaping of all codes > 128
		do
			escape_128_plus := yes
		end

feature -- Access

	escape_sequence (code: NATURAL): STRING
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

	append_escape_sequence (str: S; escape_code, code: NATURAL; table: HASH_TABLE [NATURAL, NATURAL])
		do
			str.append (escape_sequence (code))
		end

	is_escaped (code: NATURAL; table: HASH_TABLE [NATURAL, NATURAL]): BOOLEAN
		do
			if escape_128_plus and then to_unicode (code) > 128 then
				Result := True
			else
				Result := table.has_key (code)
			end
		end

feature {NONE} -- Internal attributes

	escape_128_plus: BOOLEAN

end