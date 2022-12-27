note
	description: "XML general string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-27 9:03:13 GMT (Tuesday 27th December 2022)"
	revision: "15"

deferred class
	XML_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		redefine
			append_escape_sequence, is_escaped
		end

	XML_ESCAPE_ROUTINES

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

	is_escaped (code: NATURAL; table: like code_table): BOOLEAN
		do
			if escape_128_plus and then code > 128 then
				Result := True
			else
				Result := table.has_key (code)
			end
		end

feature {NONE} -- Internal attributes

	escape_128_plus: BOOLEAN

feature {NONE} -- Constants

	Basic_entities: STRING = "<>&'%""

end