note
	description: "Implementation routeins for class ${EL_URI}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 10:25:22 GMT (Wednesday 8th November 2023)"
	revision: "8"

deferred class
	EL_URI_IMPLEMENTATION

inherit
	EL_PROTOCOL_CONSTANTS

	EL_STRING_8_CONSTANTS; EL_STRING_32_CONSTANTS; EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_BUFFER_SCOPES; EL_SHARED_STRING_32_BUFFER_SCOPES; EL_SHARED_STRING_8_BUFFER_SCOPES

	EL_SHARED_STRING_8_CURSOR

	STRING_HANDLER

feature {NONE} -- Part index

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

	authority_start_index: INTEGER
		local
			index: INTEGER
		do
			index := substring_index (Colon_slash_x2, 1)
			if index > 0 then
				Result := index + Colon_slash_x2.count
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

	path_end_index (start_index: INTEGER): INTEGER
		local
			i: INTEGER
		do
			if occurrences ('/') = 2 then
				-- Eg. http://myching.software
				Result := count
			else
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

feature {NONE} -- Implementation

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

	shared_path_copy: EL_URI_STRING_8
		do
			Result := Uri_path.emptied
			Result.append_raw_8 (internal_path (False))
		end

	substring (start_index, end_index: INTEGER; keep_ref: BOOLEAN): STRING
		do
			Result := Buffer.empty
			Result.append_substring (current_string, start_index, end_index)
			if keep_ref then
				Result := Result.twin
			end
		end

	to_uri_path: like Uri_path
		do
			Result := Uri_path.emptied
			Result.append_substring (current_string, 1, path_end_index (path_start_index))
		end

	new_encoded_parts (str: READABLE_STRING_GENERAL): SPECIAL [STRING]
		local
			index_qmark, index_hash: INTEGER
		do
			create Result.make_filled (Empty_string_8, 3)
			index_hash := str.last_index_of ('#', str.count)
			if index_hash = 0 then
				index_hash := str.count + 1

			elseif attached Uri_fragment.emptied as l_fragment then
				l_fragment.append_character ('#')
				l_fragment.append_substring_general (str, index_hash + 1, str.count)
				Result [2] := l_fragment
			end
			index_qmark := str.index_of ('?', 1)
			if index_qmark = 0 then
				index_qmark := str.count + 1

			elseif attached Uri_query.emptied as l_query then
				Result [1] := l_query
				l_query.append_character ('?')
				across String_32_scope as scope loop
					if attached scope.item as str_32 then
						str_32.append_substring_general (str, index_qmark + 1, index_hash - 1)
						l_query.append_query_string_32 (str_32)
					end
				end
			end
			Result [0] := once_encoded_substring (Uri_path, str, 1, index_qmark - 1)
		end

	once_encoded (target: EL_URI_STRING_8; str: READABLE_STRING_GENERAL): EL_URI_STRING_8
		do
			Result := once_encoded_substring (target, str, 1, str.count)
		end

	once_encoded_substring (
		target: EL_URI_STRING_8; str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER
	): EL_URI_STRING_8
		do
			Result := target.emptied
			Result.append_substring_general (str, start_index, end_index)
		end

feature {NONE} -- Deferred

	count: INTEGER
		deferred
		end

	current_string: STRING
		deferred
		end

	index_of (c: CHARACTER_8; start_index: INTEGER): INTEGER
		deferred
		end

	last_index_of (c: CHARACTER_8; start_index_from_end: INTEGER): INTEGER
		deferred
		end

	occurrences (c: CHARACTER_8): INTEGER
		deferred
		end

	substring_index (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		deferred
		end

feature {NONE} -- Constants

	Ampersand_code: STRING = "%%26"

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

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