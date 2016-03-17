note
	description: "Summary description for {EL_URL_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 23:34:25 GMT (Friday 18th December 2015)"
	revision: "5"

class
	EL_URL_ROUTINES

inherit
	UT_URL_ENCODING

feature -- Conversion

	encoded_uri (a_protocol: ZSTRING; a_path: EL_FILE_PATH; leave_reserved_unescaped: BOOLEAN): STRING
			--
		do
			Result := encoded_path (uri (a_protocol, a_path), leave_reserved_unescaped)
		end

	encoded_uri_custom (
		a_protocol: STRING; a_path: EL_FILE_PATH; unescaped_chars: DS_SET [CHARACTER]; escape_space_as_plus: BOOLEAN
	): STRING
		do
			Result := escape_custom (uri (a_protocol, a_path).to_utf_8, unescaped_chars, escape_space_as_plus)
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
			Result := a_uri.substring (a_uri.substring_index (Domain_path_separator, 1) + 3, a_uri.count)
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

	uri (a_protocol: STRING; a_path: EL_FILE_PATH): ZSTRING
		do
			create Result.make_from_latin_1 (a_protocol)
			Result.append_string_general (Domain_path_separator)
			Result.append (a_path.to_string)
		end

feature -- Status query

	is_uri (a_uri: ZSTRING): BOOLEAN
			--
		local
			components: LIST [ZSTRING]
		do
			components := a_uri.split (':')
			if components.count >= 2 and then components.i_th (2).starts_with (Double_forward_slash) and then
				across components.i_th (1).to_unicode as char all char.item.is_alpha end
			then
				Result := true
			end
		end

feature {NONE} -- Implementation

	Default_unescaped_and_reserved: DS_HASH_SET [CHARACTER]
			--
		local
			unescape_set: STRING
		once
			create unescape_set.make_empty;
			unescape_set.append_string_general (Rfc_digit_characters)
			unescape_set.append_string_general (Rfc_lowalpha_characters)
			unescape_set.append_string_general (Rfc_upalpha_characters)
			unescape_set.append_string_general (Rfc_mark_characters)
			unescape_set.append_string_general (Rfc_reserved_characters)
			Result := new_character_set (unescape_set)
		end

	Domain_path_separator: ZSTRING
		once
			Result := "://"
		end

	Double_forward_slash: ZSTRING
		once
			Result := "//"
		end

	Url_encoded_plus_sign: STRING
			--
		once
			Result := escape_string ("+")
		end

end
