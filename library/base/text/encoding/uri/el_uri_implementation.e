note
	description: "Implementation routeins for class [$source EL_URI]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-12 11:52:02 GMT (Sunday 12th September 2021)"
	revision: "1"

deferred class
	EL_URI_IMPLEMENTATION

inherit
	EL_PROTOCOL_CONSTANTS

	EL_STRING_8_CONSTANTS

	EL_STRING_32_CONSTANTS

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

	new_encoded_parts (str: READABLE_STRING_GENERAL): SPECIAL [STRING]
		local
			index_qmark, index_hash: INTEGER
			s: EL_STRING_32_BUFFER_ROUTINES
		do
			create Result.make_filled (Empty_string_8, 3)
			index_hash := str.last_index_of ('#', str.count)
			if index_hash = 0 then
				index_hash := str.count + 1

			elseif attached Uri_fragment as l_fragment then
				l_fragment.wipe_out
				l_fragment.append_character ('#')
				l_fragment.append_substring_general (str, index_hash + 1, str.count)
				Result [2] := l_fragment
			end
			index_qmark := str.index_of ('?', 1)
			if index_qmark = 0 then
				index_qmark := str.count + 1

			elseif attached Uri_query as l_query and then attached s.empty as query_string then
				Result [1] := l_query
				l_query.wipe_out
				l_query.append_character ('?')
				query_string.append_substring_general (str, index_qmark + 1, index_hash - 1)
				l_query.append_query_string_32 (query_string)
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
			Result := target; Result.wipe_out
			Result.append_substring_general (str, start_index, end_index)
		end

feature {NONE} -- Deferred

	count: INTEGER
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