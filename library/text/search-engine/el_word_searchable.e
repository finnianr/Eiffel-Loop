note
	description: "Word searchable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "18"

deferred class
	EL_WORD_SEARCHABLE

feature {NONE} -- Initialization

	make (a_word_table: like word_table)
			--
		do
			make_default
			word_table := a_word_table
		end

	make_default
		do
			word_table := Default_word_table
			create word_token_list.make_empty
		end

feature -- Element change

	set_word_table (a_word_table: like word_table)
		do
			if word_table /= a_word_table then
				word_table := a_word_table
				update_word_tokens
			end
		end

	update_word_tokens
			--
		do
			word_token_list := word_table.paragraph_list_tokens (searchable_paragraphs)
		end

feature {NONE} -- Element change

	set_word_token_list (token_list: STRING_32)
		do
			word_token_list.share (token_list)
			check_validity
		end

	check_validity
		do
			if word_token_list.is_empty
				or else not word_table.is_restored
				or else not word_table.valid_token_list (word_token_list, searchable_paragraphs)
			then
				update_word_tokens
			end
		end

feature -- Access

	word_token_list: EL_WORD_TOKEN_LIST
		-- tokenized form of `searchable_paragraphs'

	word_match_extracts (search_words: ARRAYED_LIST [EL_WORD_TOKEN_LIST]): ARRAYED_LIST [like keywords_in_bold]
			--
		local
			new_line_splitter: EL_SPLIT_ON_CHARACTER [EL_WORD_TOKEN_LIST]
			tokens: EL_WORD_TOKEN_LIST
		do
			if search_words.is_empty then
				create Result.make (0)
			else
				create Result.make (search_words.count)
				create new_line_splitter.make (word_token_list, word_table.New_line_token)
				across search_words as words loop
					across new_line_splitter as split loop
						tokens := split.item
						if tokens.has_substring (words.item) then
							Result.extend (keywords_in_bold (words.item, tokens))
						end
					end
				end
			end
		end

feature {EL_WORD_SEARCHABLE} -- Implementation

	keywords_in_bold (keyword_tokens, searchable_tokens: EL_WORD_TOKEN_LIST): EL_STYLED_TEXT_LIST [STRING_GENERAL]
			--
		local
			pos_match, start_index, end_index: INTEGER
			token_list: EL_WORD_TOKEN_LIST
		do
			create {EL_STYLED_ZSTRING_LIST} Result.make (3) -- Prevent catcall by leaving Result as general string
			pos_match := searchable_tokens.substring_index (keyword_tokens, 1)
			start_index := (pos_match - Keyword_quote_leeway).max (1)
			end_index := (pos_match + keyword_tokens.count - 1 + Keyword_quote_leeway).min (searchable_tokens.count)
			if start_index > 1 then
				Result.extend ({EL_TEXT_STYLE}.Regular, Ellipsis)
			end
			if start_index < pos_match then
				token_list := searchable_tokens.substring (start_index, pos_match - 1)
				Result.extend ({EL_TEXT_STYLE}.Regular, word_table.tokens_to_string (token_list))
			end
			Result.extend ({EL_TEXT_STYLE}.Bold, word_table.tokens_to_string (keyword_tokens))
			if end_index > pos_match + keyword_tokens.count - 1 then
				token_list := searchable_tokens.substring (pos_match + keyword_tokens.count, end_index)
				Result.extend ({EL_TEXT_STYLE}.Regular, word_table.tokens_to_string (token_list))
			end
			if end_index < searchable_tokens.count then
				Result.extend ({EL_TEXT_STYLE}.Regular, Ellipsis)
			end
		end

	searchable_paragraphs: EL_ZSTRING_LIST
		do
			Result := Once_searchable_paragraphs
			Result.wipe_out
			fill_searchable (Result)
		end

feature {EL_SEARCH_ENGINE} -- Internal attributes

	word_table: EL_WORD_TOKEN_TABLE

feature {NONE} -- Unimplemented

	fill_searchable (paragraphs: EL_ZSTRING_LIST)
		-- append to `paragraphs' the paragraphs that will be word searchable
		deferred
		end

feature {NONE} -- Constants

	Default_word_table: EL_WORD_TOKEN_TABLE
		once
			create Result.make (0)
		end

	Keyword_quote_leeway: INTEGER = 3
		-- Number of words on either side of keywords to quote in search result extract

	Once_searchable_paragraphs: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

	Ellipsis: ZSTRING
			--
		local
			s: EL_ZSTRING_ROUTINES
		once
			Result := s.n_character_string ('.', 2)
		end

end