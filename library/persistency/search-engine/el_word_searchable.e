note
	description: "Word searchable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-22 22:04:15 GMT (Friday 22nd February 2019)"
	revision: "10"

deferred class
	EL_WORD_SEARCHABLE

inherit
	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make (a_word_table: like word_table)
			--
		do
			make_default
			set_word_table (a_word_table)
		end

	make_default
		do
			create word_token_list.make_empty
			create word_table.make (0)
		end

feature -- Element change

	set_word_table (a_word_table: like word_table)
		do
			if word_table /= a_word_table then
				word_table := a_word_table
				update_searchable_words
			end
		end

	update_searchable_words
			--
		do
			word_token_list := word_table.paragraph_list_tokens (searchable_paragraphs.query_if (agent has_alpha_numeric))
		end

feature {NONE} -- Element change

	set_word_token_list (token_list: STRING_32)
		local
			paragraphs: LIST [ZSTRING]
			last_word_token: CHARACTER_32
		do
			paragraphs := searchable_paragraphs.query_if (agent has_alpha_numeric)
			if not paragraphs.is_empty then
				if not word_table.is_restored or else token_list.is_empty then
					update_searchable_words

				else
					last_word_token := word_table.item (last_word (paragraphs.last)).to_character_32

					if token_list.occurrences (word_table.Paragraph_separator) + 1 = paragraphs.count
						and token_list.item (token_list.count) = last_word_token
					then
						create word_token_list.make_from_tokens (token_list)

						-- In case tokens files is corrupted and missing some values
						if word_table.is_incomplete (word_token_list) then
							update_searchable_words
						end
					end
				end
			end
		end

feature -- Access

	word_token_list: EL_WORD_TOKEN_LIST

	word_match_extracts (search_words: ARRAYED_LIST [EL_WORD_TOKEN_LIST]): ARRAYED_LIST [like keywords_in_bold]
			--
		local
			tokens_list: LIST [EL_WORD_TOKEN_LIST]
		do
			if search_words.is_empty then
				create Result.make (0)
			else
				create Result.make (search_words.count)
				from search_words.start until search_words.after loop
					tokens_list := word_token_list.split (word_table.Paragraph_separator)
					from tokens_list.start until tokens_list.after loop
						if tokens_list.item.has_substring (search_words.item) then
							Result.extend (keywords_in_bold (search_words.item, tokens_list.item))
						end
						tokens_list.forth
					end
					search_words.forth
				end
			end
		end

feature {EL_WORD_SEARCHABLE} -- Implementation

	fixed_styled (str: ZSTRING): EL_MONOSPACED_STYLED_TEXT
			--
		do
			Result := str
		end

	keywords_in_bold (keyword_tokens, searchable_tokens: EL_WORD_TOKEN_LIST): EL_MIXED_STYLE_TEXT_LIST
			--
		local
			pos_match, start_index, end_index: INTEGER
			token_list: EL_WORD_TOKEN_LIST
		do
			create Result.make (3)
			pos_match := searchable_tokens.substring_index (keyword_tokens, 1)
			start_index := (pos_match - Keyword_quote_leeway).max (1)
			end_index := (pos_match + keyword_tokens.count - 1 + Keyword_quote_leeway).min (searchable_tokens.count)
			if start_index > 1 then
				Result.extend (Styled_ellipsis)
			end
			if start_index < pos_match then
				token_list := searchable_tokens.substring (start_index, pos_match - 1)
				Result.extend (styled (word_table.tokens_to_string (token_list)))
			end
			Result.extend (styled (word_table.tokens_to_string (keyword_tokens)))
			Result.last.set_bold
			if end_index > pos_match + keyword_tokens.count - 1 then
				token_list := searchable_tokens.substring (pos_match + keyword_tokens.count, end_index)
				Result.extend (styled (word_table.tokens_to_string (token_list)))
			end
			if end_index < searchable_tokens.count then
				Result.extend (Styled_ellipsis)
			end
		end

	last_word (paragraph: ZSTRING): ZSTRING
		local
			i: INTEGER
		do
			create Result.make (20)
			from i := paragraph.count until i < 1 or else paragraph.item (i).is_alpha_numeric loop
				i := i - 1
			end
			from until i < 1 or else not paragraph.item (i).is_alpha_numeric loop
				Result.append_character (paragraph.item (i))
				i := i - 1
			end
			Result.mirror
			Result.to_lower
		end

	has_alpha_numeric (str: ZSTRING): BOOLEAN
		-- `True' if `str' has an alpha numeric character
		local
			i: INTEGER
		do
			from i := 1 until Result or i > str.count loop
				Result := str.is_alpha_numeric_item (i)
				i := i + 1
			end
		end

	styled (str: ZSTRING): EL_STYLED_TEXT
			--
		do
			Result := str
		end

feature {EL_SEARCH_ENGINE} -- Internal attributes

	word_table: EL_WORD_TOKEN_TABLE

feature {EL_SEARCH_ENGINE} -- Unimplemented

	searchable_paragraphs: EL_CHAIN [ZSTRING]
		deferred
		end

feature {NONE} -- Constants

	Keyword_quote_leeway: INTEGER = 3
		-- Number of words on either side of keywords to quote in search result extract

	Styled_ellipsis: EL_STYLED_TEXT
			--
		once
			Result := n_character_string_8 ('.', 2)
		end

end
