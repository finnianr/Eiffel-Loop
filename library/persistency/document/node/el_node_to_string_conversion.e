note
	description: "Routines for converting document node to types conforming to `STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-20 14:13:03 GMT (Sunday 20th December 2020)"
	revision: "4"

deferred class
	EL_NODE_TO_STRING_CONVERSION

inherit
	EL_SHARED_UTF_8_ZCODEC

	EL_SHARED_ONCE_STRING_8

	EL_SHARED_ONCE_STRING_32

	EL_SHARED_ONCE_ZSTRING

feature -- To Zstring

	to_normalized_case_string: ZSTRING
			--
		do
			Result := to_normalized_case_string_32
		end

	to_raw_string: ZSTRING
			--
		do
			Result := raw_content
		end

	to_set_match (a_set: ITERABLE [ZSTRING]): ZSTRING
		-- matching item in `a_set' or else `to_string'
		local
			found: BOOLEAN
		do
			across a_set as set until found loop
				if same_as (set.item) then
					Result := set.item
					found := True
				end
			end
			if not found then
				Result := to_string
			end
		end

	to_string: ZSTRING
			--
		do
			Result := raw_adjusted
		end

	to_trim_lines: EL_ZSTRING_LIST
			-- left and right adjusted list of line strings
		do
			create Result.make_with_lines (to_string)
			across Result as line loop
				line.item.adjust
			end
		end

feature -- To Latin-1

	to_set_match_8 (a_set: ITERABLE [STRING]): STRING
		-- matching item in `a_set' or else `to_string_8'
		local
			found: BOOLEAN
		do
			across a_set as set until found loop
				if same_as (set.item) then
					Result := set.item
					found := True
				end
			end
			if not found then
				Result := to_string_8
			end
		end

	to_string_8: STRING
			--
		do
			Result := raw_content
			Result.adjust
		end

feature -- To UTF-8

	to_normalized_case_utf_8: STRING
			--
		do
			Result := Utf_8_codec.as_utf_8 (to_normalized_case_string_32, True)
		end

	to_raw_utf_8: STRING
			--
		do
			Result := Utf_8_codec.as_utf_8 (raw_content, True)
		end

	to_utf_8: STRING
			--
		do
			Result := Utf_8_codec.as_utf_8 (raw_adjusted, True)
		end

feature -- To UTF-32

	to_normalized_case_string_32: STRING_32
			--
		local
			words: LIST [STRING_32]; word: STRING_32
		do
			words := to_string_32.split (' ')
			create Result.make_empty
			from words.start until words.after loop
				word := words.item
				word.to_lower
				if word.count >= 3 or words.index = 1 then
					word.put (word.item (1).as_upper, 1)
				end
				if words.index > 1 then
					Result.append_character (Blank_character)
				end
				Result.append (word)
				words.forth
			end
		end

	to_raw_string_32: STRING_32
			--
		do
			Result := raw_content.string
		end

	to_set_match_32 (a_set: ITERABLE [STRING_32]): STRING_32
		-- matching item in `a_set' or else `to_string_32'
		local
			found: BOOLEAN
		do
			across a_set as set until found loop
				if same_as (set.item) then
					Result := set.item
					found := True
				end
			end
			if not found then
				Result := to_string_32
			end
		end

	to_string_32, unicode: STRING_32
			--
		do
			Result := raw_content.string
			Result.adjust
		end

feature -- Basic operations

	put_string_into (a_set: EL_HASH_SET [ZSTRING])
		local
			item: ZSTRING
		do
			item := once_copy_general (raw_adjusted)
			if not a_set.has_key (item) then
				a_set.extend (item.twin)
			end
		end

	put_string_8_into (a_set: EL_HASH_SET [STRING_8])
		local
			item: STRING_8
		do
			item := once_general_copy_8 (raw_adjusted)
			if not a_set.has_key (item) then
				a_set.extend (item.twin)
			end
		end

	put_string_32_into (a_set: EL_HASH_SET [STRING_32])
		local
			item: STRING_32
		do
			item := raw_adjusted
			if not a_set.has_key (item) then
				a_set.extend (item.twin)
			end
		end

feature -- Status query

	same_as (a_string: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached {STRING_32} a_string as str then
				Result := str ~ raw_adjusted
			else
				Result := a_string.same_string (raw_adjusted)
			end
		end

	is_empty: BOOLEAN
			--
		do
			Result := raw_adjusted.is_empty
		end

	is_raw_empty: BOOLEAN
			--
		do
			Result := raw_content.is_empty
		end

feature {NONE} -- Implementation	

	raw_adjusted: STRING_32
		deferred
		end

	raw_content: STRING_32
		deferred
		end

feature -- Constant

	Blank_character: CHARACTER_8
			--
		once
			Result := {ASCII}.Blank.to_character_8
		end

end