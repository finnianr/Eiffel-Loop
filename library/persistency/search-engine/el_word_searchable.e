note
	description: "Summary description for {EL_WORD_SEARCHABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-09 9:45:27 GMT (Saturday 9th December 2017)"
	revision: "4"

deferred class
	EL_WORD_SEARCHABLE

inherit
	EL_STRING_CONSTANTS

feature {NONE} -- Initialization

	make (a_word_table: like word_table)
			--
		do
			make_default
			set_word_table (a_word_table)
		end

	make_default
		do
			create searchable_words.make_empty
			create word_table.make (0)
		end

feature -- Element change

	set_word_table (a_word_table: like word_table)
		do
			word_table := a_word_table
			searchable_words.set_word_table (a_word_table)
			searchable_words.append_word (New_paragraph_symbol)
			searchable_words.remove_tail (1)
		end

	update_searchable_words
			--
		do
			set_searchable_words_from_paragraphs (tokenized_paragraphs (searchable_paragraphs_with_words))
		end

feature {NONE} -- Element change

	set_searchable_words (a_word_tokens: STRING_32)
		local
			paragraphs: like searchable_paragraphs
			last_word_token, paragraph_divider_token: CHARACTER_32
		do
			paragraphs := searchable_paragraphs_with_words
			if not paragraphs.is_empty then
				if not word_table.is_restored or else a_word_tokens.is_empty then
					update_searchable_words

				else
					paragraph_divider_token := word_table.item (New_paragraph_symbol).to_character_32
					last_word_token := word_table.item (last_word (paragraphs.last)).to_character_32

					if a_word_tokens.occurrences (paragraph_divider_token) + 1 = paragraphs.count
						and a_word_tokens.item (a_word_tokens.count) = last_word_token
					then
						create searchable_words.make_from_tokens (word_table, a_word_tokens)

						-- In case tokens files is corrupted and missing some values
						if searchable_words.incomplete_word_table then
							searchable_words.clear_incomplete_word_table
							update_searchable_words
						end
					end
				end
			end
		end

	set_searchable_words_from_paragraphs (a_tokenized_paragraphs: LIST [EL_TOKENIZED_STRING])
			--
		local
			old_count: INTEGER
		do
			old_count := word_table.count

			searchable_words.wipe_out
			across a_tokenized_paragraphs as list loop
				if not searchable_words.is_empty then
				 	searchable_words.append_word (New_paragraph_symbol)
				end
				searchable_words.append (list.item)
			end
			if word_table.count > old_count then
				word_table.flush
			end
		end

feature -- Access

	word_match_extracts (search_words: ARRAYED_LIST [EL_TOKENIZED_STRING]): ARRAYED_LIST [like keywords_in_bold]
			--
		local
			tokens_list: LIST [EL_TOKENIZED_STRING]
			token_divider: CHARACTER_32
		do
			token_divider := searchable_words.token (New_paragraph_symbol)
			if search_words.is_empty then
				create Result.make (0)
			else
				create Result.make (search_words.count)
				from search_words.start until search_words.after loop
					tokens_list := searchable_words.split (token_divider)
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

	searchable_words: EL_TOKENIZED_STRING

feature {EL_WORD_SEARCHABLE, EL_SEARCH_ENGINE} -- Implementation

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

	tokenized_paragraphs (paragraphs: LIST [ZSTRING]): ARRAYED_LIST [EL_TOKENIZED_STRING]
			--
		do
			create Result.make (paragraphs.count)
			across paragraphs as list loop
				Result.extend (create {EL_TOKENIZED_STRING}.make_from_string (word_table, list.item))
			end
		end

	keywords_in_bold (keyword_tokens, searchable_tokens: EL_TOKENIZED_STRING): EL_MIXED_STYLE_TEXT_LIST
			--
		local
			pos_match, start_index, end_index: INTEGER
		do
			create Result.make (3)
			pos_match := searchable_tokens.substring_index (keyword_tokens, 1)
			start_index := (pos_match - Keyword_quote_leeway).max (1)
			end_index := (pos_match + keyword_tokens.count - 1 + Keyword_quote_leeway).min (searchable_tokens.count)
			if start_index > 1 then
				Result.extend (Styled_ellipsis)
			end
			if start_index < pos_match then
				Result.extend (
					styled (searchable_tokens.substring (start_index, pos_match - 1).words)
				)
			end
			Result.extend (styled (keyword_tokens.words))
			Result.last.set_bold
			if end_index > pos_match + keyword_tokens.count - 1 then
				Result.extend (
					styled (searchable_tokens.substring (pos_match + keyword_tokens.count, end_index).words)
				)
			end
			if end_index < searchable_tokens.count then
				Result.extend (Styled_ellipsis)
			end
		end

	styled (str: ZSTRING): EL_STYLED_TEXT
			--
		do
			Result := str
		end

	fixed_styled (str: ZSTRING): EL_MONOSPACED_STYLED_TEXT
			--
		do
			Result := str
		end

	searchable_paragraphs_with_words: ARRAYED_LIST [ZSTRING]
		local
			paragraphs: like searchable_paragraphs
			i: INTEGER
			is_alpha_numeric: BOOLEAN
			paragraph: ZSTRING
		do
			paragraphs := searchable_paragraphs
			create Result.make (paragraphs.count)
			across paragraphs as p loop
				paragraph := p.item
				from is_alpha_numeric := False; i := 1 until is_alpha_numeric or i > paragraph.count loop
					is_alpha_numeric := paragraph.is_alpha_numeric_item (i)
					i := i + 1
				end
				if is_alpha_numeric then
					Result.extend (paragraph)
				end
			end
		end

	word_table: EL_WORD_TOKEN_TABLE

feature {NONE} -- Unimplemented

	searchable_paragraphs: LIST [ZSTRING]
		deferred
		end

feature {NONE} -- Constants

	Keyword_quote_leeway: INTEGER = 3
		-- Number of words on either side of keywords to quote in search result extract

	New_paragraph_symbol: ZSTRING
		once
			Result := "<*>"
		end

	Styled_ellipsis: EL_STYLED_TEXT
			--
		once
			Result := Ellipsis_string_8
		end

end
