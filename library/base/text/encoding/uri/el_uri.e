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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-11 16:08:19 GMT (Friday 11th June 2021)"
	revision: "24"

class
	EL_URI

inherit
	STRING
		rename
			make as make_with_size,
			make_from_string as make,
			substring as uri_substring
		export
			{NONE} all
			{ANY} hash_code, to_string_8, is_empty, starts_with, has_substring
			{STRING_HANDLER} append, append_string_general, wipe_out, share, prune_all_trailing
		redefine
			make
		end

create
	make_empty, make, make_from_general, make_with_size

convert
	make ({STRING_8})

feature {STRING_HANDLER} -- Initialization

	make (uri: READABLE_STRING_8)
		require else
			valid_uri: uri.substring_index (Colon_slash_x2, 1) > 0
		do
			Precursor (uri)
		end

	make_from_general (unencoded_string: READABLE_STRING_GENERAL)
		local
			l_path: like Uri_path
		do
			l_path := Uri_path; l_path.wipe_out
			l_path.append_general (unencoded_string)
			make (l_path)
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

	scheme: STRING
		do
			Result := substring (1, scheme_end_index, True)
		end

feature -- Conversion

	to_dir_path: EL_DIR_PATH
		do
			create Result.make (once_path_copy.decoded_32 (False))
		end

	to_file_path: EL_FILE_PATH
		do
			create Result.make (once_path_copy.decoded_32 (False))
		end

	to_string: ZSTRING
		local
			l_path: like Uri_path
		do
			l_path := Uri_path; l_path.wipe_out
			l_path.append_substring (Current, 1, path_end_index (path_start_index))
			Result := l_path.decoded
		end

feature -- Element change

	join (a_path: EL_PATH)
		require
			valid_path: not is_empty implies not a_path.is_absolute
		local
			encoded: like Uri_path
		do
			encoded := Uri_path; encoded.wipe_out
			encoded.append_character (Separator)
			a_path.append_to_uri (encoded)
			insert_string (encoded, path_end_index (1) + 1)
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
			Result := scheme ~ once "file"
		end

feature {NONE} -- Implementation

	authority_start_index: INTEGER
		local
			index: INTEGER
		do
			index := substring_index (Colon_slash_x2, 1)
			if index > 0 then
				Result := index + Colon_slash_x2.count
			end
		end

	authority_end_index (start_index: INTEGER): INTEGER
		local
			index: INTEGER
		do
			if start_index > 0 then
				index := index_of (Separator, start_index)
				if index > 0 then
					Result := index - 1
				end
			end
		end

	fragment_start_index: INTEGER
		local
			index: INTEGER
		do
			index := index_of ('#', 1)
			if index > 0 then
				Result := index + 1
			end
		end

	internal_path (keep_ref: BOOLEAN): STRING
		local
			start_index, index, end_index: INTEGER
		do
			index := path_start_index
			if index > 0 then
				start_index := index; end_index := path_end_index (start_index)
			end
			if start_index > 0 then
				Result := substring (start_index, end_index, keep_ref)
			else
				Result := substring (1, 0, keep_ref)
			end
		end

	last_separator_index: INTEGER
		local
			start_index: INTEGER
		do
			start_index := path_start_index
			if start_index > 0 then
				Result := last_index_of (Separator, path_end_index (start_index))
				if Result < start_index then
					Result := 0
				end
			end
		end

	once_encoded (target: EL_URI_STRING_8; str: READABLE_STRING_GENERAL): EL_URI_STRING_8
		do
			Result := target; Result.wipe_out
			Result.append_general (str)
		end

	once_path_copy: EL_URI_STRING_8
		do
			Result := Uri_path; Result.wipe_out
			Result.append_raw_8 (internal_path (False))
		end

	path_end_index (start_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			from i := 1; until i > 2 or Result > 0 loop
				Result := index_of (Qmark_and_hash [i], start_index)
				i := i + 1
			end
			if Result > 0 then
				Result := Result - 1
			else
				Result := count
			end
		end

	path_start_index: INTEGER
		do
			Result := authority_start_index
			if Result > 0 then
				Result := index_of (Separator, Result)
			end
		end

	query_end_index (start_index: INTEGER): INTEGER
		local
			index: INTEGER
		do
			index := index_of ('#', start_index)
			if index > 0 then
				Result := index - 1
			else
				Result := count
			end
		end

	query_start_index: INTEGER
		local
			index: INTEGER
		do
			index := index_of ('?', 1)
			if index > 0 then
				Result := index + 1
			end
		end

	scheme_end_index: INTEGER
		local
			index: INTEGER
		do
			index := index_of (':', 1)
			if index > 0 then
				Result := index - 1
			end
		end

	substring (start_index, end_index: INTEGER; keep_ref: BOOLEAN): STRING
		local
			buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			Result := buffer.empty
			Result.append_substring (Current, start_index, end_index)
			if keep_ref then
				Result := Result.twin
			end
		end

feature {STRING_HANDLER} -- Constants

	Colon_slash_x2: STRING = "://"

feature {NONE} -- Constants

	Qmark_and_hash: STRING = "?#"

	Separator: CHARACTER = '/'

	Uri_fragment: EL_URI_QUERY_STRING_8
		once
			create Result.make_empty
		end

	Uri_path: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

	Uri_query: EL_URI_QUERY_STRING_8
		once
			create Result.make_empty
		end

end