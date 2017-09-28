note
	description: "[
		A tokenized string which forms the basis of a fast full text search engine.
		The initializing string argument is decomposed into a series of lowercased words ignoring punctuation.
		The resulting word-list is represented as a series of token id's which are keys into a table of unique words.
		Each token is of type `CHARACTER_32'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-24 10:49:19 GMT (Sunday 24th September 2017)"
	revision: "2"

class
	EL_TOKENIZED_STRING

inherit
	STRING_32
		rename
			make as make_tokens,
			string as string_tokens,
			make_from_string as make_from_tokens_string
		redefine
			out, make_empty, substring
		end

create
	make, make_empty, make_from_string, make_from_tokens

feature {NONE} -- Initialization

	make_empty
		do
			Precursor
			create word_table.make (0)
		end

	make (a_word_table: like word_table; n: INTEGER)
		do
			make_tokens (n)
			word_table := a_word_table
		end

	make_from_string (a_word_table: like word_table; str: ZSTRING)
			--
		do
			make_empty
			word_table := a_word_table
			append_as_tokenized_lower (str)
		end

	make_from_tokens (a_word_table: like word_table; a_tokens: STRING_32)
			--
		local
			i: INTEGER; l_code, l_max_code: NATURAL l_missing_token: BOOLEAN
		do
			make_tokens (a_tokens.count)
			word_table := a_word_table
			l_max_code := word_table.words.count.to_natural_32
			from i := 1 until l_missing_token or i > a_tokens.count loop
				l_code := a_tokens.code (i)
				if l_code > l_max_code then
					l_missing_token := True
				else
					append_code (l_code)
				end
				i := i + 1
			end
			incomplete_word_table := l_missing_token
		end

feature -- Access

	words: ZSTRING
			-- space separated words
		do
			Result := word_table.tokens_to_string (Current)
		end

	token (word: ZSTRING): CHARACTER_32
			--
		do
			word_table.search (word)
			if word_table.found then
				Result := word_table.last_code.to_character_32
			end
		end

	out: STRING
		local
			i: INTEGER
		do
			create Result.make (count * 10)
			from i := 1 until i > count loop
				if i > 1 then
					Result.append (", ")
				end
				Result.append_integer (item_code (i))
				i := i + 1
			end
		end

	to_hexadecimal_string: STRING
		local
			i: INTEGER
			hexadecimal: STRING
		do
			create Result.make (count * 4)
			from i := 1 until i > count loop
				if i > 1 then
					Result.append_character (' ')
				end
				hexadecimal := item_code (i).to_hex_string
				hexadecimal.prune_all_leading ('0')
				Result.append (hexadecimal)
				i := i + 1
			end
		end

feature -- Element change

	append_word (word: ZSTRING)
			--
		local
			exception: EXCEPTION
		do
			if word.has ('%U') then
				create exception
				exception.set_description ("Invalid word: " + word)
				exception.raise
			end
			word_table.put (word)
			extend (word_table.last_code.to_character_32)
		end

	append_as_tokenized_lower (str: ZSTRING)
			--
		local
			i: INTEGER; word: ZSTRING
		do
			resize (count + str.occurrences (' ') + 3)
			create word.make (12)
			from i := 1 until i > str.count loop
				if str.is_alpha_numeric_item (i) then
					word.append_z_code (str.z_code (i))
				else
					if not word.is_empty then
						append_word (word.as_lower)
						word.wipe_out
					end
				end
				i := i + 1
			end
			if not word.is_empty then
				append_word (word.as_lower)
			end
		end

	set_word_table (a_word_table: like word_table)
		do
			word_table := a_word_table
		end

feature -- Status query

	incomplete_word_table: BOOLEAN
		-- True if table has some missing values

feature -- Status setting

	clear_incomplete_word_table
		do
			incomplete_word_table := False
		end

feature -- Duplication

	substring (start_index, end_index: INTEGER): like Current
			-- Copy of substring containing all characters at indices
			-- between `start_index' and `end_index'
		do
			Result := Precursor (start_index, end_index)
			Result.set_word_table (word_table)
		end

feature {NONE} -- Implementation

	word_table: EL_WORD_TOKEN_TABLE

end
