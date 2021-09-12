note
	description: "Uri routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-12 11:41:42 GMT (Sunday 12th September 2021)"
	revision: "12"

frozen class
	EL_URI_ROUTINES

inherit
	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

	EL_PROTOCOL_CONSTANTS

feature -- Status query

	has_scheme (uri: READABLE_STRING_GENERAL; a_scheme: STRING): BOOLEAN
		do
			if uri.starts_with (a_scheme) then
				Result := uri.substring_index (Colon_slash_x2, a_scheme.count) = a_scheme.count + 1
			end
		end

	is_absolute (uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			if is_file (uri) then
				Result := path_start_index (uri) = 8
			else
				Result := path_start_index (uri) > 0
			end
		end

	is_file (uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has_scheme (uri, Protocol.file)
		end

	is_http (uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has_scheme (uri, Protocol.http)
		end

	is_http_any (uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := is_http (uri) or else is_https (uri)
		end

	is_https (uri: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has_scheme (uri, Protocol.https)
		end

	is_valid (uri: READABLE_STRING_GENERAL): BOOLEAN
		local
			index, i: INTEGER
		do
			index := uri.substring_index (Colon_slash_x2, 1)
			if index > 3 then
				Result := True
				from i := 1 until i = index or not Result loop
					inspect uri [i]
						when 'a' .. 'z', 'A' .. 'Z' then
					else
						Result := False
					end
					i := i + 1
				end
			end
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

	path_start_index (uri: READABLE_STRING_GENERAL): INTEGER
		local
			index: INTEGER
		do
			index := uri.substring_index (Colon_slash_x2, 1)
			if index > 0 then
				Result := uri.index_of ('/', index + Colon_slash_x2.count)
			end
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

	scheme (uri: READABLE_STRING_GENERAL): STRING
		local
			index: INTEGER
		do
			index :=  uri.substring_index (Colon_slash_x2, 1)
			if index > 0 then
				create Result.make (index - 1)
				Result.append_substring_general (uri, 1, index - 1)
			else
				create Result.make_empty
			end
		end

feature -- Factory

	new_url (a_url: READABLE_STRING_GENERAL): EL_URL
		local
			s: EL_STRING_8_ROUTINES
		do
			if attached {READABLE_STRING_8} a_url as str_8 and then s.is_ascii (str_8) then
				create Result.make (str_8)
			else
				create Result.make_from_general (a_url)
			end
		end

end