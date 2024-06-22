note
	description: "Xml element attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-22 5:26:20 GMT (Saturday 22nd June 2024)"
	revision: "9"

class
	XML_ELEMENT_ATTRIBUTE

inherit
	EL_NAME_VALUE_PAIR [ZSTRING]

	EL_STRING_GENERAL_ROUTINES

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (nvp_pair: READABLE_STRING_GENERAL)
		do
			make (as_zstring (nvp_pair), '=')
			if value.enclosed_with ("%"%"") then
				value.remove_head (1)
				value.remove_tail (1)
			end
		end

feature -- Conversion

	escaped (escaper: XML_ESCAPER [ZSTRING]; keep_ref: BOOLEAN): ZSTRING
		do
			Result := Once_buffer
			Result.wipe_out
			Result.append (name)
			Result.append_character ('=')
			Result.append_character ('"')
			Result.append (escaper.escaped (value, False))
			Result.append_character ('"')
			if keep_ref then
				Result := Result.twin
			end
		end

	to_string (keep_ref: BOOLEAN): ZSTRING
		do
			Result := Once_buffer
			Result.wipe_out
			Result.append (name)
			Result.append_character ('=')
			Result.append_character ('"')
			Result.append (value)
			Result.append_character ('"')
			if keep_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Constants

	Once_buffer: ZSTRING
		once
			create Result.make_empty
		end
end