note
	description: "Uri routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 11:18:29 GMT (Thursday 28th May 2020)"
	revision: "9"

frozen class
	EL_URI_ROUTINES

inherit
	EL_PROTOCOL_CONSTANTS
		export
			{NONE} all
		end

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

	EL_MODULE_CHAR_8

feature -- Status query

	is_file (uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := is_valid (uri) and then scheme (uri) ~ Protocol.file
		end

	is_http (uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := is_valid (uri) and then Http_protocols.has (scheme (uri))
		end

	is_valid (uri: READABLE_STRING_GENERAL): BOOLEAN
		local
			index: INTEGER
		do
			index := uri.substring_index (Colon_slash_x2, 1)
			if index >= 3 and then uri.count > index + Colon_slash_x2.count
				and then is_alpha_string (uri.substring (1, index - 1))
			then
				Result := True
			end
		end

	is_of_type (uri, type: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := scheme (uri) ~ as_zstring (type)
		end

feature -- Access

	path (uri: READABLE_STRING_GENERAL): ZSTRING
		local
			index: INTEGER
		do
			index := uri.substring_index (Colon_slash_x2, 1)
			if index >= 3 then
				Result := as_zstring (uri.substring (index + Colon_slash_x2.count, uri.count))
			else
				create Result.make_empty
			end
		end

	scheme (uri: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := as_zstring (uri.substring (1, uri.substring_index (Colon_slash_x2, 1) - 1))
		end

	remove_protocol_prefix (a_uri: READABLE_STRING_GENERAL): ZSTRING
			--
		require
			is_valid_uri: is_valid (a_uri)
		local
			index: INTEGER
		do
			index := a_uri.substring_index (Colon_slash_x2, 1)
			if index > 0 then
				Result := as_zstring (a_uri.substring (index + 3, a_uri.count))
			else
				Result := as_zstring (a_uri)
			end
		end

feature {NONE} -- Implementation

	is_alpha_string (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := str.is_valid_as_string_8 and then across str.to_string_8 as c all
				Char_8.is_a_to_z_caseless (c.item)
			end
		end

end
