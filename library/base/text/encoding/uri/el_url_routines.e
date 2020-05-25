note
	description: "Url routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 12:38:15 GMT (Sunday 24th May 2020)"
	revision: "8"

class
	EL_URL_ROUTINES

inherit
	EL_URI_ROUTINES

feature -- Conversion

	decoded_path (escaped_utf8_path: STRING): ZSTRING
			--
		local
			uri: like URI_string
		do
			uri := URI_string; uri.share (escaped_utf8_path)
			uri.escape_space_as_plus
			uri.set_reserved_characters (URI_reserved_chars.allowed_in_path)
			Result := uri.decoded
		end

	decoded_path_latin_1 (escaped_path: STRING): STRING
			--
		local
			uri: like URI_string
		do
			uri := URI_string; uri.share (escaped_path)
			uri.escape_space_as_plus
			Result := uri.to_latin_1
		end

	encoded (str: ZSTRING): STRING
		do
			Result := encoded_custom (str.to_utf_8, URI_reserved_chars.rfc_2396, False)
		end

	encoded_path (a_path: ZSTRING): STRING
			--
		local
			uri: like URI_string
		do
			uri := URI_string
			uri.set_reserved_characters (URI_reserved_chars.allowed_in_path)
			uri.set_from_string (a_path)
			create Result.make_from_string (uri)
		end

	encoded_uri_custom (a_uri: EL_URI_PATH; reserved_char_set: STRING; escape_space_as_plus: BOOLEAN): STRING
		do
			Result := encoded_custom (a_uri.to_utf_8, reserved_char_set, escape_space_as_plus)
		end

	encoded_custom (a_string: STRING; reserved_char_set: STRING; escape_space_as_plus: BOOLEAN): STRING
		local
			uri: like URI_string
		do
			uri := URI_string
			uri.set_reserved_characters (reserved_char_set)
			uri.set_plus_sign_equals_space (escape_space_as_plus)
			uri.set_from_string (a_string)
			create Result.make_from_string (uri)
		end

	remove_protocol_prefix (a_uri: ZSTRING): ZSTRING
			--
		require
			is_valid_uri: is_uri (a_uri)
		do
			Result := a_uri.substring_end (a_uri.substring_index (Colon_slash_x2, 1) + 3)
		end

feature {NONE} -- Constants

	URI_string: EL_URI_STRING_8
		once
			create Result.make_empty
		end

end
