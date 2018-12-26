note
	description: "[
		A table of unique words used to create tokenized strings that can be reassembled into
		the original string.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-26 12:06:19 GMT (Wednesday 26th December 2018)"
	revision: "1"

class
	EL_ZSTRING_TOKEN_TABLE

inherit
	EL_UNIQUE_CODE_TABLE [ZSTRING]
		export
			{ANY} is_empty, count, has_key
		redefine
			put, make
		end

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal, copy
		end

	EL_ZSTRING_ROUTINES
		rename
			joined as joined_iterable
		undefine
			is_equal, copy
		end

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

feature -- Access

	iterable_to_token_list (list: FINITE [READABLE_STRING_GENERAL]): STRING_32
		require
			finite_and_iterable: attached {ITERABLE [READABLE_STRING_GENERAL]} list
		do
			create Result.make (list.count + 1) -- Allow extra for {EL_PATH}.base
			if attached {ITERABLE [READABLE_STRING_GENERAL]} list as iterable_list then
				across iterable_list as string loop
					Result.extend (token (new_zstring (string.item)))
				end
			end
		end

	joined (a_tokens: STRING_32; separator: CHARACTER_32): ZSTRING
		-- strings represented by `a_tokens' joined with `separator'
		local
			i: INTEGER; area: SPECIAL [CHARACTER_32]; word_area: SPECIAL [ZSTRING]
			list: like Once_string_list
		do
			area := a_tokens.area; word_area := word_list.area
			list := Once_string_list
			list.wipe_out
			from i := 0 until i = a_tokens.count loop
				list.extend (word_area [area.item (i).code - 1])
				i := i + 1
			end
			Result := list.joined (separator)
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
				Result.extend (word_area [area.item (i).code - 1])
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
			list: like Split_list
			new_word: ZSTRING
		do
			list := Split_list
			list.set_string (string, character_string (separator))
			create Result.make (list.count + 1) -- Allow extra for {EL_PATH}.base
			from list.start until list.after loop
				search (list.item)
				if not found then
					new_word := list.item.twin
					extend (count + 1, new_word)
					word_list.extend (new_word)
					last_code := count
				end
				Result.extend (last_token)
				list.forth
			end
		ensure
			reversible: string ~ joined (Result, separator)
		end

	token_string (a_token: CHARACTER_32): ZSTRING
		require
			valid_token: word_list.valid_index (a_token.code)
		do
			Result := word_list.i_th (a_token.code)
		end

	word_list: ARRAYED_LIST [ZSTRING]

feature {NONE} -- Constants

	Once_string_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end
	Split_list: EL_SPLIT_ZSTRING_LIST
		once
			create Result.make_empty
		end

end
