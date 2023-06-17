note
	description: "Uri routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-17 9:11:27 GMT (Saturday 17th June 2023)"
	revision: "17"

class
	EL_URI_ROUTINES_IMP

inherit
	EL_ZSTRING_ROUTINES_IMP
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

	encoded_path (str: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): EL_URI_PATH_STRING_8
		do
			Result := Uri_path.emptied
			Result.append_general (str)
			if keep_ref then
				Result := Result.twin
			end
		end

	encoded_path_element (str: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): EL_URI_PATH_ELEMENT_STRING_8
		do
			Result := Uri_path_element.emptied
			Result.append_general (str)
			if keep_ref then
				Result := Result.twin
			end
		end

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

	new_uri_string (is_url: BOOLEAN): EL_URI_QUERY_STRING_8
		do
			if is_url then
				create {EL_URL_QUERY_STRING_8} Result.make_empty
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Constants

	Uri_path: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

	Uri_path_element: EL_URI_PATH_ELEMENT_STRING_8
		once
			create Result.make_empty
		end

end