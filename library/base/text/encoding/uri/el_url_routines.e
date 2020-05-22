note
	description: "Url routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 10:33:23 GMT (Friday 22nd May 2020)"
	revision: "7"

class
	EL_URL_ROUTINES

inherit
	UT_URL_ENCODING

	EL_URI_ROUTINES

feature -- Conversion

	encoded_uri (a_uri: EL_URI_PATH; leave_reserved_unescaped: BOOLEAN): STRING
			--
		do
			Result := encoded_path (a_uri.to_utf_8, leave_reserved_unescaped)
		end

	encoded_uri_custom (a_uri: EL_URI_PATH; unescaped_chars: DS_SET [CHARACTER]; escape_space_as_plus: BOOLEAN): STRING
		do
			Result := escape_custom (a_uri.to_utf_8, unescaped_chars, escape_space_as_plus)
		end

	encoded (str: ZSTRING): STRING
		do
			Result := escape_custom (str.to_utf_8, Default_unescaped, False)
		end

	encoded_path (a_path: ZSTRING; leave_reserved_unescaped: BOOLEAN): STRING
			--
		do
			if leave_reserved_unescaped then
				Result := escape_custom (a_path.to_utf_8, Default_unescaped_and_reserved, False)
			else
				Result := escape_custom (a_path.to_utf_8, Default_unescaped, False)
			end
		end

	decoded_path_latin_1 (escaped_path: STRING): STRING
			--
		do
			create Result.make_from_string (escaped_path)
			Result.replace_substring_all (once "+", Url_encoded_plus_sign)
			Result := unescape_string (Result)
		end

	remove_protocol_prefix (a_uri: ZSTRING): ZSTRING
			--
		require
			is_valid_uri: is_uri (a_uri)
		do
			Result := a_uri.substring_end (a_uri.substring_index (Protocol_sign, 1) + 3)
		end

	decoded_path (escaped_utf8_path: STRING): ZSTRING
			--
		local
			l_escaped_path: STRING
		do
			l_escaped_path := escaped_utf8_path.twin
			l_escaped_path.replace_substring_all ("+", Url_encoded_plus_sign)
			create Result.make_from_utf_8 (unescape_string (l_escaped_path))
		end

feature {NONE} -- Implementation

	Default_unescaped_and_reserved: DS_HASH_SET [CHARACTER]
			--
		once
			Result := new_character_set (
				Rfc_digit_characters + Rfc_lowalpha_characters + Rfc_upalpha_characters +
				Rfc_mark_characters + Rfc_reserved_characters
			)
		end

	Url_encoded_plus_sign: STRING
			--
		once
			Result := escape_string ("+")
		end

end
