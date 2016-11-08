note
	description: "Summary description for {EL_JSON_NAME_VALUE_PAIR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-04 8:13:43 GMT (Tuesday 4th October 2016)"
	revision: "2"

class
	EL_JSON_NAME_VALUE_PAIR

inherit
	EL_NAME_VALUE_PAIR [ZSTRING]
		rename
			make as make_pair,
			set_from_string as set_from_delimited_string
		export
			{NONE} set_from_delimited_string
		end

	EL_MODULE_STRING_8

	EL_SHARED_ONCE_STRINGS

create
	make, make_empty

feature {NONE} -- Initialization

	make (str: ZSTRING)
		do
			make_pair (str, ':')
		end

feature -- Element change

	set_from_string (string: ZSTRING)
		do
			set_from_delimited_string (string, ':')
			value.prune_all_trailing (',')
			name.remove_quotes; value.remove_quotes
			decode (name); decode (value)
		end

feature {NONE} -- Implementation

	decode (string: ZSTRING)
		local
			pos_encoded: INTEGER; hex_digits: STRING; code: INTEGER
			str: like Once_string
		do
			from pos_encoded := 1 until pos_encoded = 0 loop
				pos_encoded := string.substring_index (Encoding_mark, pos_encoded)
				if pos_encoded > 0 then
					hex_digits := string.substring (pos_encoded + 2, pos_encoded + 5).to_latin_1
					code := String_8.hexadecimal_to_integer (hex_digits)
					str := empty_once_string
					str.append_unicode (code.to_natural_32)
					string.replace_substring (str, pos_encoded, pos_encoded + 5)
					pos_encoded := pos_encoded + 1
				end
			end
		end

feature -- Constants

	Encoding_mark: ZSTRING
		once
			Result := "\u"
		end
end
