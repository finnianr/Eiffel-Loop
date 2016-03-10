note
	description: "Summary description for {EL_URL_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:16:31 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_URL_ROUTINES

inherit
	UT_URL_ENCODING

	EL_MODULE_STRING

	EL_MODULE_UTF

feature -- Conversion

	uri (a_protocol: STRING; a_path: EL_FILE_PATH): EL_ASTRING
		do
			create Result.make_from_latin1 (a_protocol)
			Result.append ("://")
			Result.append (a_path.to_string)
		end

	encoded_uri (a_protocol: STRING; a_path: EL_FILE_PATH; leave_reserved_unescaped: BOOLEAN): STRING
			--
		do
			Result := encoded_path (uri (a_protocol, a_path).to_utf8, leave_reserved_unescaped)
		end

	encoded_uri_custom (
		a_protocol: STRING; a_path: EL_FILE_PATH; unescaped_chars: DS_SET [CHARACTER]; escape_space_as_plus: BOOLEAN
	): STRING
		do
			Result := escape_custom (uri (a_protocol, a_path).to_utf8, unescaped_chars, escape_space_as_plus)
		end

	encoded_path (path: STRING; leave_reserved_unescaped: BOOLEAN): STRING
			--
		do
			if leave_reserved_unescaped then
				Result := escape_custom (path, Default_unescaped_and_reserved, False)
			else
				Result := escape_custom (path, Default_unescaped, False)
			end
		end

	decoded_path (escaped_path: STRING): STRING
			--
		do
			create Result.make_from_string (escaped_path)
			Result.replace_substring_all ("+", Url_encoded_plus_sign)
			Result := unescape_string (Result)
		end

	unicode_decoded_path (escaped_utf8_path: STRING): EL_ASTRING
			--
		local
			l_escaped_path: STRING
		do
			l_escaped_path := escaped_utf8_path.twin
			l_escaped_path.replace_substring_all ("+", Url_encoded_plus_sign)
			create Result.make_from_utf8 (unescape_string (l_escaped_path))
		end

	remove_protocol_prefix (a_uri: EL_ASTRING): EL_ASTRING
			--
		require
			is_valid_uri: is_uri (a_uri)
		do
			Result := a_uri.substring (a_uri.substring_index ("://", 1) + 3, a_uri.count)
		end

feature -- Status query

	is_uri (a_uri: EL_ASTRING): BOOLEAN
			--
		local
			components: LIST [EL_ASTRING]
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
