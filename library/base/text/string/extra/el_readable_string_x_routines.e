note
	description: "Routines for strings conforming to [$source READABLE_STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-30 9:01:49 GMT (Thursday 30th June 2022)"
	revision: "1"

deferred class
	EL_READABLE_STRING_X_ROUTINES [S -> READABLE_STRING_GENERAL]

inherit
	STRING_HANDLER

feature -- Status query

	has_double_quotes (s: S): BOOLEAN
			--
		do
			Result := has_quotes (s, 2)
		end

	has_enclosing (s, ends: S): BOOLEAN
			--
		require
			ends_has_2_characters: ends.count = 2
		do
			Result := s.count >= 2
				and then s.item (1) = ends.item (1) and then s.item (s.count) = ends.item (2)
		end

	has_quotes (s: S; type: INTEGER): BOOLEAN
		require
			double_or_single: 1 <= type and type <= 2
		local
			quote_code: NATURAL
		do
			if type = 1 then
				quote_code := ('%'').natural_32_code
			else
				quote_code := ('"').natural_32_code
			end
			Result := s.count >= 2 and then s.code (1) = quote_code and then s.code (s.count) = quote_code
		end

	has_single_quotes (s: S): BOOLEAN
			--
		do
			Result := has_quotes (s, 1)
		end

	is_identifier_boundary (str: S; lower, upper: INTEGER): BOOLEAN
		-- `True' if indices `lower' to `upper' are an identifier boundary
		do
			Result := True
			if upper + 1 <= str.count then
				Result := not is_identifier_character (str, upper + 1)
			end
			if Result and then lower - 1 >= 1 then
				Result := not is_identifier_character (str, lower - 1)
			end
		end

feature -- Character query

	is_identifier_character (str: S; i: INTEGER): BOOLEAN
		deferred
		end

feature -- Substring

	adjusted (str: S): S
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - cursor (str).trailing_white_count
			if end_index.to_boolean then
				start_index := cursor (str).leading_white_count + 1
			else
				start_index := 1
			end
			if start_index = 1 and then end_index = str.count then
				Result := str
			else
				Result := str.substring (start_index, end_index)
			end
		end

	substring_to (str: S; uc: CHARACTER_32; start_index_ptr: POINTER): S
		-- substring from INTEGER at memory location `start_index_ptr' up to but not including index of `uc'
		-- or else `substring_end (start_index)' if `uc' not found
		-- `start_index' is 1 if `start_index_ptr = Default_pointer'
		-- write new start_index back to `start_index_ptr'
		-- if `uc' not found then new `start_index' is `count + 1'
		local
			start_index, index: INTEGER; pointer: EL_POINTER_ROUTINES
		do
			if start_index_ptr = Default_pointer then
				start_index := 1
			else
				start_index := pointer.read_integer (start_index_ptr)
			end
			index := str.index_of (uc, start_index)
			if index > 0 then
				Result := str.substring (start_index, index - 1)
				start_index := index + 1
			else
				Result := str.substring (start_index, str.count)
				start_index := str.count + 1
			end
			if start_index_ptr /= Default_pointer then
				start_index_ptr.memory_copy ($start_index, {PLATFORM}.Integer_32_bytes)
			end
		end

	substring_to_reversed (str: S; uc: CHARACTER_32; start_index_from_end_ptr: POINTER): S
		-- the same as `substring_to' except going from right to left
		-- if `uc' not found `start_index_from_end' is set to `0' and written back to `start_index_from_end_ptr'
		local
			start_index_from_end, index: INTEGER; pointer: EL_POINTER_ROUTINES
		do
			if start_index_from_end_ptr = Default_pointer then
				start_index_from_end := str.count
			else
				start_index_from_end := pointer.read_integer (start_index_from_end_ptr)
			end
			index := last_index_of (str, uc, start_index_from_end)
			if index > 0 then
				Result := str.substring (index + 1, start_index_from_end)
				start_index_from_end := index - 1
			else
				Result := str.substring (1, start_index_from_end)
				start_index_from_end := 0
			end
			if start_index_from_end_ptr /= Default_pointer then
				pointer.put_integer (start_index_from_end, start_index_from_end_ptr)
			end
		end

	truncated (str: S; max_count: INTEGER): S
		-- return `str' truncated to `max_count' characters, adding ellipsis where necessary
		do
			if str.count <= max_count then
				Result := str
			else
				Result := str.substring (1, max_count - 2) + Ellipsis_dots
			end
		end

feature {NONE} -- Implementation

	cursor (s: S): EL_STRING_ITERATION_CURSOR
		deferred
		end

	last_index_of (str: S; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		deferred
		end

	Ellipsis_dots: STRING = ".."

end