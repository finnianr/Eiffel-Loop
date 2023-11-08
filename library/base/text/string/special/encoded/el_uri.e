note
	description: "Uniform Resource Identifier as defined by [https://tools.ietf.org/html/rfc3986 RFC 3986]"
	notes: "[
	  The following are two example URIs and their component parts:

			  foo://example.com:8042/over/there?name=ferret#nose
			  \_/   \______________/\_________/ \_________/ \__/
			   |           |            |            |        |
			scheme     authority       path        query   fragment
			   |   _____________________|__
			  / \ /                        \
			  urn:example:animal:ferret:nose
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 10:26:35 GMT (Wednesday 8th November 2023)"
	revision: "43"

class
	EL_URI

inherit
	STRING
		rename
			make as make_with_size,
			substring as uri_substring,
			String_searcher as String_8_searcher
		export
			{NONE} all
			{ANY} hash_code, to_string_8, is_empty, starts_with, has_substring, last_index_of, count
			{STRING_HANDLER} append, wipe_out, share, prune_all_trailing
		redefine
			to_string_32
		end

	EL_URI_IMPLEMENTATION
		export
			{STRING_HANDLER} Colon_slash_x2
		undefine
			copy, is_equal, out, String_8_searcher
		end

create
	make_empty, make, make_from_general, make_with_size

convert
	make ({STRING_8, IMMUTABLE_STRING_8})

feature {NONE} -- Initialization

	make (uri: READABLE_STRING_8)
		require
			valid_uri: uri.substring_index (Colon_slash_x2, 1) > 1
		do
			if cursor_8 (uri).all_ascii then
				make_from_string (uri)
			else
				make_from_unencoded (uri)
			end
		end

	make_from_general (str: READABLE_STRING_GENERAL)
		do
			if str.is_valid_as_string_8 then
				make (str.as_string_8)
			else
				make_from_unencoded (str)
			end
		end

	make_from_unencoded (unencoded: READABLE_STRING_GENERAL)
		do
			if attached new_encoded_parts (unencoded) as encoded then
				make_with_size (parts_count (encoded))
				append_parts (encoded)
			end
		end

feature -- Access

	authority: STRING
		local
			start_index, end_index: INTEGER
		do
			start_index := authority_start_index
			end_index := authority_end_index (start_index)
			if end_index > 0 then
				Result := substring (start_index, end_index, True)
			else
				Result := substring (1, 0, True)
			end
		end

	fragment: STRING
		local
			index: INTEGER
		do
			index := index_of ('#', 1)
			if index > 0 then
				Result := substring (index + 1, count, True)
			else
				Result := substring (1, 0, True)
			end
		end

	joined (a_path: EL_PATH): like Current
		do
			Result := twin
			Result.join (a_path)
		end

	parent: like Current
		do
			Result := twin
			Result.remove_step
		end

	path: STRING
		do
			Result := internal_path (True)
		end

	query: STRING
		local
			start_index, end_index: INTEGER
		do
			start_index := query_start_index
			if start_index > 0 then
				end_index := query_end_index (start_index)
			end
			if end_index > 0 then
				Result := substring (start_index, end_index, True)
			else
				Result := substring (1, 0, True)
			end
		end

	query_table: EL_URI_QUERY_ZSTRING_HASH_TABLE
		do
			create Result.make_url (query)
		end

	scheme: STRING
		do
			Result := substring (1, scheme_end_index, True)
		end

feature -- Conversion

	to_dir_path: DIR_PATH
		do
			create Result.make (shared_path_copy.decoded_32 (False))
		end

	to_file_path: FILE_PATH
		do
			create Result.make (shared_path_copy.decoded_32 (False))
		end

	to_string: ZSTRING
		-- decoded string
		do
			Result := to_uri_path.decoded
			if query_start_index > 0 then
				Result.append_character ('?')
				Result.append (decoded_query)
			end
		end

	to_string_32: STRING_32
		-- decoded unicode string
		do
			if query_start_index > 0 then
				across String_32_scope as scope loop
					if attached scope.item as decoded then
						to_uri_path.decode_to (decoded)
						decoded.append_character ('?')
						decoded_query.append_to_string_32 (decoded)
						Result := decoded.twin
					end
				end
			else
				Result := to_uri_path.decoded_32 (True)
			end
		end

feature -- Basic operations

	append_to (general: STRING_GENERAL)
		do
			general.append (to_uri_path.decoded_32 (False))
		end

	decoded_query: ZSTRING
		local
			pair_split: EL_URI_QUERY_PAIRS_SPLIT
		do
			create pair_split.make (query, is_url)
			across String_scope as scope loop
				if attached scope.item as str then
					pair_split.append_as_unencoded (str)
					Result := str.twin
				end
			end
		end

feature -- Element change

	append_general (unencoded: READABLE_STRING_GENERAL)
		-- append `unencoded' string
		do
			if attached new_encoded_parts (unencoded) as encoded then
				grow (parts_count (encoded))
				append_parts (encoded)
			end
		end

	append_query_from_table (value_table: HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL])
		-- append `value_table' to `query' part of URI
		do
			replace_query_from_table (value_table, True)
		end

	join (a_path: EL_PATH)
		require
			valid_path: not is_empty implies not a_path.is_absolute
		do
			if attached Uri_path.emptied as encoded then
				if count > 0 and then item (count) /= Separator then
					encoded.append_character (Separator)
				end
				a_path.append_to_uri (encoded)
				insert_string (encoded, path_end_index (1) + 1)
			end
		end

	remove_step
		-- remove the last path step, query and fragment
		local
			index: INTEGER
		do
			index := last_separator_index
			if index > 0 then
				keep_head (last_separator_index - 1)
				trim
			end
		end

	set_authority (a_authority: READABLE_STRING_GENERAL)
		local
			start_index: INTEGER
		do
			start_index := authority_start_index
			replace_substring (a_authority.to_string_8, start_index, authority_end_index (start_index))
		end

	set_encoded_query (encoded: READABLE_STRING_8)
		local
			start_index: INTEGER
		do
			start_index := query_start_index
			if start_index > 0 then
				replace_substring (encoded, start_index, query_end_index (start_index))
			else
				start_index := fragment_start_index
				if start_index > 0 then
					insert_character ('?', start_index - 1)
					insert_string (encoded, start_index)
				else
					append_character ('?')
					append (encoded)
				end
			end
		end

	set_fragment (str: READABLE_STRING_GENERAL)
		local
			start_index: INTEGER
		do
			start_index := fragment_start_index
			if start_index > 0 then
				replace_substring (once_encoded (Uri_fragment, str), start_index, count)
			else
				append_character ('#')
				append (once_encoded (Uri_fragment, str))
			end
		end

	set_path (str: READABLE_STRING_GENERAL)
		local
			start_index, end_index: INTEGER
		do
			start_index := path_start_index
			if start_index > 0 then
				end_index := path_end_index (start_index)
				if end_index > 0 then
					replace_substring (once_encoded (Uri_path, str), start_index, end_index)
				end
			end
		end

	set_query (str: READABLE_STRING_GENERAL)
		do
			set_encoded_query (once_encoded (Uri_query, str))
		end

	set_query_from_table (value_table: HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL])
		do
			replace_query_from_table (value_table, false)
		end

	set_scheme (a_scheme: READABLE_STRING_GENERAL)
		do
			replace_substring (a_scheme.to_string_8, 1, scheme_end_index)
		end

feature -- Status query

	has_parent: BOOLEAN
		do
			Result := last_separator_index.to_boolean
		end

	is_file: BOOLEAN
		do
			Result := scheme ~ Protocol.file
		end

	is_http: BOOLEAN
		do
			Result := scheme ~ Protocol.http
		end

	is_https: BOOLEAN
		do
			Result := scheme ~ Protocol.https
		end

	is_url: BOOLEAN
		do
			Result := False
		end

feature -- Contract Support

	is_unencoded (str: READABLE_STRING_8): BOOLEAN
		do
			Result := cursor_8 (str).all_ascii
		end

feature {NONE} -- Implementation

	append_parts (parts: like new_encoded_parts)
		local
			i: INTEGER
		do
			from i := 0 until i = 3 loop
				append (parts [i])
				i := i + 1
			end
		end

	current_string: STRING
		do
			Result := Current
		end

	parts_count (parts: like new_encoded_parts): INTEGER
		local
			i: INTEGER
		do
			from i := 0 until i = 3 loop
				Result := Result + parts [i].count
				i := i + 1
			end
		end

	replace_query_from_table (
		value_table: HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL]; appending: BOOLEAN
	)
		do
			if attached Uri_query as l_query then
				l_query.wipe_out
				if appending and then query_start_index.to_boolean then
					l_query.append_raw_8 (query)
				end
				across value_table as table loop
					if l_query.count > 0 then
						l_query.append_character ('&')
					end
					l_query.append_general (table.key)
					l_query.append_character ('=')
					l_query.append_general (table.item)
				end
				set_encoded_query (l_query)
			end
		end

end