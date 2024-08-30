note
	description: "XML element attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-30 12:32:19 GMT (Friday 30th August 2024)"
	revision: "11"

class
	XML_ELEMENT_ATTRIBUTE

inherit
	EL_NAME_VALUE_PAIR [ZSTRING]

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (nvp_pair: READABLE_STRING_GENERAL)
		do
			make_quoted (nvp_pair, '=')
		end

feature -- Conversion

	escaped (escaper: XML_ESCAPER [ZSTRING]; keep_ref: BOOLEAN): ZSTRING
		do
			Result := Buffer.copied (name)
			Result.append_raw_string_8 (Equal_quote)
			Result.append (escaper.escaped (value, False))
			Result.append_character_8 ('"')
			if keep_ref then
				Result := Result.twin
			end
		end

	to_string (keep_ref: BOOLEAN): ZSTRING
		do
			Result := Buffer.copied (name)
			Result.append_raw_string_8 (Equal_quote)
			Result.append (value)
			Result.append_character_8 ('"')
			if keep_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Constants

	Equal_quote: STRING = "=%""

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end
end