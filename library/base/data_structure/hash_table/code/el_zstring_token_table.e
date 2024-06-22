note
	description: "[
		A table of unique words used to create tokenized strings that can be reassembled into
		the original string.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-22 5:54:01 GMT (Saturday 22nd June 2024)"
	revision: "17"

class
	EL_ZSTRING_TOKEN_TABLE

inherit
	EL_UNIQUE_CODE_TABLE [ZSTRING]
		export
			{ANY} is_empty, count, has_key, prunable
		redefine
			put, make, is_equal, wipe_out
		end

	EL_STRING_GENERAL_ROUTINES

create
	make

feature -- Initialization

	make (n: INTEGER)
			--
		do
			Precursor (n)
			create word_list.make (n)
		end

feature -- Element change

	append (a_words: ITERABLE [ZSTRING])
		do
			across a_words as word loop
				put (word.item)
			end
		end

	append_table (table: EL_ZSTRING_TOKEN_TABLE)
		do
			append (table.word_list)
		end

	put (word: ZSTRING)
			--
		do
			Precursor (word)
			if not found then
				word_list.extend (word)
			end
		ensure then
			same_count: count = word_list.count
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := Precursor {EL_UNIQUE_CODE_TABLE} (other) and then word_list.is_equal (other.word_list)
		end

feature -- Access

	iterable_to_token_list (list: FINITE [READABLE_STRING_GENERAL]): STRING_32
		require
			finite_and_iterable: attached {ITERABLE [READABLE_STRING_GENERAL]} list
		do
			create Result.make (list.count + 1) -- Allow extra for {EL_PATH}.base
			if attached {ITERABLE [READABLE_STRING_GENERAL]} list as iterable_list then
				across iterable_list as string loop
					Result.extend (token (as_zstring (string.item)))
				end
			end
		end

	joined (a_tokens: STRING_32; separator: CHARACTER_32): ZSTRING
		-- strings represented by `a_tokens' joined with `separator'
		local
			i, i_final: INTEGER; area: SPECIAL [CHARACTER_32]; word_area: SPECIAL [ZSTRING]
		do
			area := a_tokens.area; word_area := word_list.area
			if attached Once_string_list.emptied as list then
				i_final := a_tokens.count
				from i := 0 until i = i_final loop
					list.extend (word_area [area.item (i).code - 1])
					i := i + 1
				end
				Result := list.joined (separator)
			end
		end

	last_token: CHARACTER_32
		do
			Result := last_code.to_character_32
		end

	string_list (a_tokens: STRING_32): EL_ZSTRING_LIST
		local
			i: INTEGER; area: SPECIAL [CHARACTER_32]; word_area: SPECIAL [ZSTRING]
		do
			area := a_tokens.area; word_area := word_list.area
			create Result.make (a_tokens.count)
			from i := 0 until i = a_tokens.count loop
				Result.extend (word_area.item (area.item (i).code - 1).twin)
				i := i + 1
			end
		end

	token (string: ZSTRING): CHARACTER_32
		do
			put (string)
			Result := last_token
		ensure
			reversible: string ~ token_string (Result)
		end

	token_list (string: ZSTRING; separator: CHARACTER_32): STRING_32
		local
			split_list: EL_SPLIT_ZSTRING_ON_CHARACTER; new_word: ZSTRING
		do
			create split_list.make (string, separator)
			create Result.make (string.occurrences (separator) + 2) -- Allow extra for {EL_PATH}.base
			across split_list as list loop
				search (list.item)
				if not found then
					new_word := list.item_copy
					extend (count + 1, new_word)
					word_list.extend (new_word)
					last_code := count
				end
				Result.extend (last_token)
			end
		ensure
			reversible: string ~ joined (Result, separator)
		end

feature -- Removal

	wipe_out
			-- Reset all items to default values; reset status.
		do
			Precursor
			word_list.wipe_out
		end


feature {STRING_HANDLER, EL_ZSTRING_TOKEN_TABLE} -- Implementation

	token_string (a_token: CHARACTER_32): ZSTRING
		require
			valid_token: word_list.valid_index (a_token.code)
		do
			Result := word_list.i_th (a_token.code)
		end

	word_list: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Once_string_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

end