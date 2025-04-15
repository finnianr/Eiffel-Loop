note
	description: "[
		Abstract interface to tokenized text parsed by implementation of ${EL_TOKEN_PARSER [EL_FILE_LEXER]}
	]"
	descendants: "[
			EL_TOKEN_TEXT_I*
				${EL_TOKEN_PARSER* [L -> EL_FILE_LEXER create make end]}
					${EVC_COMPILER}
				${EVC_PARSE_ACTIONS*}
					${EVC_COMPILER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 12:41:38 GMT (Tuesday 15th April 2025)"
	revision: "2"

deferred class
	EL_TOKEN_TEXT_I

inherit
	EL_MODULE_CONVERT_STRING

feature -- Access

	index_of (a_token: NATURAL; start_index, end_index: INTEGER): INTEGER
		require
			valid_slice_indices: valid_slice_indices (start_index, end_index)
		local
			i: INTEGER
		do
			from i := start_index until i > end_index or Result > 0 loop
				if tokens_text.code (i) = a_token then
					Result := i
				else
					i := i + 1
				end
			end
		end

	shared_token_text_8 (i: INTEGER; unquoted: BOOLEAN): IMMUTABLE_STRING_8
		-- latin-1 text with shared `area' corresponding to i'th token in matched_tokens
		-- if `unquoted' is true assume the text has quotation marks which should be removed
		require
			valid_token_index: valid_index (i)
			token_text_valid_as_latin_1: is_token_text_latin_1 (i)
		local
			start_index, end_index: INTEGER
		do
			if attached source_interval_list as list then
				start_index := list.i_th_lower (i) + unquoted.to_integer
				end_index := list.i_th_upper (i) - unquoted.to_integer
				if end_index + 1 >= start_index then
					Result := source_text.to_shared_immutable_8.shared_substring (start_index, end_index)
				else
					create Result.make_empty
				end
			end
		end

	token_integer_64 (i: INTEGER): INTEGER_64
		-- INTEGER_64 value corresponding to i'th token in matched_tokens
		require
			valid_token_index: valid_index (i)
			token_is_real_64: token_text (i).is_integer_64
		local
			start_index, end_index: INTEGER
		do
			if attached source_interval_list as list then
				start_index := list.i_th_lower (i); end_index := list.i_th_upper (i)
				if attached source_text.to_shared_immutable_8 as str then
					Result := Convert_string.substring_to_integer_64 (str, start_index, end_index)
				end
			end
		end

	token_real_64 (i: INTEGER): REAL_64
		-- REAL_64 value corresponding to i'th token in matched_tokens
		require
			valid_token_index: valid_index (i)
			token_is_real_64: token_text (i).is_real_64
		local
			start_index, end_index: INTEGER
		do
			if attached source_interval_list as list then
				start_index := list.i_th_lower (i); end_index := list.i_th_upper (i)
				if attached source_text.to_shared_immutable_8 as str then
					Result := Convert_string.substring_to_real_64 (str, start_index, end_index)
				end
			end
		end

	token_text (i: INTEGER): ZSTRING
		-- source text corresponding to i'th token in matched_tokens
		require
			valid_token_index: valid_index (i)
		do
			if attached source_interval_list as list then
				Result := source_text.substring (list.i_th_lower (i), list.i_th_upper (i))
			end
		end

	unquoted_token_text (i: INTEGER): ZSTRING
		-- source text corresponding to i'th token in matched_tokens
		require
			valid_token_index: valid_index (i)
		local
			start_index, end_index: INTEGER
		do
			if attached source_interval_list as list then
				start_index := list.i_th_lower (i) + 1; end_index := list.i_th_upper (i) - 1
				if end_index + 1 >= start_index then
					Result := source_text.substring (start_index, end_index)
				else
					create Result.make_empty
				end
			end
		end

feature -- Measurement

	occurrences (a_token: NATURAL; start_index, end_index: INTEGER): INTEGER
		-- count of `a_token' between `start_index' and `end_index'
		require
			valid_slice_indices: valid_slice_indices (start_index, end_index)
		local
			i: INTEGER
		do
			from i := start_index until i > end_index loop
				if tokens_text.code (i) = a_token then
					Result := Result + 1
				end
				i := i + 1
			end
		end

feature -- Status query

	is_token_text_latin_1 (i: INTEGER): BOOLEAN
		-- `True' if token text is valid as latin-1 string
		require
			valid_token_index: valid_index (i)
		local
			start_index, end_index: INTEGER
		do
			if attached source_interval_list as list  then
				start_index := list.i_th_lower (i); end_index := list.i_th_upper (i)
				Result := source_text.is_substring_valid_as_string_8 (start_index, end_index)
			end
		end

	is_token_integer_64 (i: INTEGER): BOOLEAN
		-- `True' if token text is valid as INTEGER_64
		require
			valid_token_index: valid_index (i)
		local
			start_index, end_index: INTEGER
		do
			if attached source_interval_list as list  then
				start_index := list.i_th_lower (i); end_index := list.i_th_upper (i)
				Result := source_text.substring (start_index, end_index).is_integer_64
			end
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := source_interval_list.valid_index (i)
		end

	valid_slice_indices (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `start_index' and `end_index' are valid indices for `tokens_text.substring'
		do
			if valid_index (start_index) then
				Result := end_index >= start_index - 1 and end_index <= tokens_text.count
			end
		end

feature {NONE} -- Deferred

	source_interval_list: EL_ARRAYED_INTERVAL_LIST
		-- substring intervals for `source_text'
		deferred
		end

	source_text: ZSTRING
		deferred
		end

	tokens_text: STRING_32
		deferred
		end

end