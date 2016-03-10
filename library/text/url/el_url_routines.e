note
	description: "Summary description for {EL_URL_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-16 13:49:39 GMT (Wednesday 16th October 2013)"
	revision: "3"

class
	EL_URL_ROUTINES

inherit
	UT_URL_ENCODING

	EL_MODULE_STRING

	EL_MODULE_UTF

feature -- Conversion

	encoded_uri (a_protocol: STRING; a_path: EL_FILE_PATH; leave_reserved_unescaped: BOOLEAN): STRING
			--
		do
			Result := encoded_path (uri (a_protocol, a_path), leave_reserved_unescaped)
		end

	encoded_uri_custom (
		a_protocol: STRING; a_path: EL_FILE_PATH; unescaped_chars: DS_SET [CHARACTER]; escape_space_as_plus: BOOLEAN
	): STRING
		do
			Result := escape_custom (uri (a_protocol, a_path).to_utf8, unescaped_chars, escape_space_as_plus)
		end

	encoded (uc_string: READABLE_STRING_GENERAL): STRING
		do
			Result := escape_custom (String.as_utf8 (uc_string), Default_unescaped, False)
		end

	encoded_path (uc_path: READABLE_STRING_GENERAL; leave_reserved_unescaped: BOOLEAN): STRING
			--
		local
			utf8_path: STRING
		do
			utf8_path := String.as_utf8 (uc_path)
			if leave_reserved_unescaped then
				Result := escape_custom (utf8_path, Default_unescaped_and_reserved, False)
			else
				Result := escape_custom (utf8_path, Default_unescaped, False)
			end
		end

	decoded_path (escaped_path: STRING): STRING
			--
		do
			create Result.make_from_string (escaped_path)
			Result.replace_substring_all (once "+", Url_encoded_plus_sign)
			Result := unescape_string (Result)
		end

	remove_protocol_prefix (a_uri: ASTRING): ASTRING
			--
		require
			is_valid_uri: is_uri (a_uri)
		do
			Result := a_uri.substring (a_uri.substring_index (once "://", 1) + 3, a_uri.count)
		end

	unicode_decoded_path (escaped_utf8_path: STRING): ASTRING
			--
		local
			l_escaped_path: STRING
		do
			l_escaped_path := escaped_utf8_path.twin
			l_escaped_path.replace_substring_all ("+", Url_encoded_plus_sign)
			create Result.make_from_utf8 (unescape_string (l_escaped_path))
		end

	uri (a_protocol: STRING; a_path: EL_FILE_PATH): ASTRING
		do
			create Result.make_from_latin1 (a_protocol)
			Result.append_string ("://")
			Result.append (a_path)
		end

feature -- Status query

	is_uri (a_uri: ASTRING): BOOLEAN
			--
		local
			components: LIST [ASTRING]
		do
			components := a_uri.split (':')
			if components.count >= 2 and then components.i_th (2).starts_with ("//") and then
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

	Url_encoded_plus_sign: STRING
			--
		once
			Result := escape_string ("+")
		end

end
