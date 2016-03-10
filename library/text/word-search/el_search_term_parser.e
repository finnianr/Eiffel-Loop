note
	description: "Summary description for {SEARCH_TERM_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SEARCH_TERM_PARSER

inherit
	EL_FILE_PARSER
		rename
			set_source_text as set_search_terms
		export
			{NONE} all
			{ANY} set_search_terms
		redefine
			make, reset, set_search_terms
		end

	EL_EIFFEL_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create word_token_table.make (1)
			create criteria.make (10)
			create match_words.make (5)
			create last_phrase_tokens.make_empty
			Precursor
		end

feature {NONE} -- Initialization

	reset
			--
		do
			criteria.wipe_out
			match_words.wipe_out
			Precursor
		end

feature -- Access

	match_words: ARRAYED_LIST [EL_TOKENIZED_STRING]

	criteria: ARRAYED_LIST [EL_SEARCH_TERM]

feature -- Status query

	is_valid: BOOLEAN

feature -- Element Change

 	set_search_terms (search_terms: STRING)
 			--
 		do
 			Precursor (search_terms)
			match_full
			is_valid := full_match_succeeded
			if is_valid then
				consume_events
			end
 		end

	set_word_table (a_word_table: like word_token_table)
			--
		do
			word_token_table := a_word_table
		end

feature {NONE} -- Text patterns

	new_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<< maybe_non_breaking_white_space, one_or_more (search_term) >>)
		end

	search_term: EL_RECURSIVE_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := pattern_1_or_else_recursive_pattern_2 (
				all_of (<< positive_or_negated_search_term, not operator_OR >>), agent either_search_term
			)
		end

	either_search_term: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<< positive_or_negated_search_term, operator_OR, search_term >>)
			Result.set_action_on_match_end (agent on_either_search_term)
		end

	operator_OR: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<< string_literal ("OR"), non_breaking_white_space >>)
		end

	positive_or_negated_search_term: EL_MATCH_ALL_IN_LIST_TP
			--
		local
			negated_term: EL_MATCH_ALL_IN_LIST_TP
		do
			negated_term := all_of (<< character_literal ('-'), positive_search_term >>)
			negated_term.set_action_on_match_end (agent on_negated)
			Result := all_of (<<
				one_of (<< negated_term, positive_search_term >>),
				one_of (<< end_of_line_character, non_breaking_white_space >>)
			>>)
		end

	positive_search_term: EL_FIRST_MATCH_IN_LIST_TP
		do
			create Result.make (custom_patterns)
			Result.extend (quoted_phrase_ending_with_word_stem)
			Result.extend (quoted_phrase)
			Result.extend (word_stem_plus_wildcard)
			Result.extend (default_word)
		end

	default_word: EL_MATCH_ONE_OR_MORE_TIMES_TP
			--
		do
			Result := one_or_more (not white_space_character) |to| agent on_default_word
		end

	quoted_phrase: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				quoted_string_with_escape_sequence (string_literal ("\%""), agent on_default_word)
			>>)
		end

	word_stem_plus_wildcard: EL_MATCH_ALL_IN_LIST_TP
			-- Match: app* -> apple, application, apply etc
		do
			Result := all_of (<<
				latin1_alpha_numeric #occurs (3 |..| 20) |to| agent on_word_stem_plus_wildcard,
				character_code_literal ({ASCII}.star.to_natural_32)
			>>)
		end

	quoted_phrase_ending_with_word_stem: EL_MATCH_ALL_IN_LIST_TP
			--
		local
			quoted_characters: EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP
		do
			quoted_characters := while_not_pattern_1_repeat_pattern_2 (
--				pattern 1
				all_of (<<
					latin1_alpha_numeric #occurs (3 |..| 20) |to| agent on_quoted_phrase_end_word_stem,
					string_literal ("*%"")
				>>),

--				pattern 2
				any_character
			)
			quoted_characters.set_action_on_combined_repeated_match (agent on_quoted_phrase_ending_with_word_stem)
			Result := all_of (<< character_literal ('"'), quoted_characters >>)
		end

feature {NONE} -- Match actions

	on_negated (matched_text: EL_STRING_VIEW)
		do
			criteria.last.set_inverse
			if attached {EL_CONTAINS_WORDS_SEARCH_TERM} criteria.last as last then
				match_words.finish
				match_words.remove
			end
		end

	on_default_word (matched_text: EL_STRING_VIEW)
			--
		local
			word_tokens: EL_TOKENIZED_STRING
		do
			log.enter_with_args ("on_default_word", << matched_text.view >>)
			create word_tokens.make_from_string (word_token_table, matched_text)

			log.put_string_field ("Tokens", word_tokens.out)
			log.put_new_line

			criteria.extend (create {EL_CONTAINS_WORDS_SEARCH_TERM}.make (word_tokens))
			match_words.extend (word_tokens)
			log.exit
		end

	on_word_stem_plus_wildcard (matched_text: EL_STRING_VIEW)
		local
			word_stem: EL_ASTRING
		do
			word_stem := matched_text
			word_stem.prune_all_trailing ('*')
			add_one_of_words_search_term_criteria (create {EL_TOKENIZED_STRING}.make (word_token_table, 0), word_stem)
		end

	on_quoted_phrase_end_word_stem (matched_text: EL_STRING_VIEW)
		do
			add_one_of_words_search_term_criteria (last_phrase_tokens, matched_text)
		end

	on_quoted_phrase_ending_with_word_stem (matched_text: EL_STRING_VIEW)
		do
			create last_phrase_tokens.make_from_string (word_token_table, matched_text)
		end

	on_either_search_term (matched_text: EL_STRING_VIEW)
			--
		require
			at_least_two_criteria_operands: criteria.count >= 2
		local
			either_criteria: EL_OPERATOR_OR_SEARCH_TERM
		do
			create either_criteria.make (criteria [criteria.count - 1], criteria.last)
			criteria.finish
			criteria.remove
			criteria [criteria.count] := either_criteria
		end

feature {NONE} -- Implementation

	add_one_of_words_search_term_criteria (phrase_stem_words: EL_TOKENIZED_STRING; word_stem: EL_ASTRING)
		local
			word_list: like word_token_table.words
			potential_match_word, word_variations: EL_TOKENIZED_STRING
			end_word_token: NATURAL
			word_stem_lower: EL_ASTRING
		do
			word_stem_lower := word_stem.as_lower
			create word_variations.make (word_token_table, 20)
			word_list := word_token_table.words
			from word_list.start until word_list.after loop
				if word_list.item.starts_with (word_stem_lower) then
					end_word_token := word_list.index.to_natural_32
					word_variations.append_code (end_word_token)

					create potential_match_word.make (word_token_table, phrase_stem_words.count + 1)
					potential_match_word.append (phrase_stem_words)
					potential_match_word.append_code (end_word_token)
					match_words.extend (potential_match_word)
				end
				word_list.forth
			end
			criteria.extend (create {EL_ONE_OF_WORDS_SEARCH_TERM}.make (phrase_stem_words, word_variations))
		end

	word_token_table: EL_WORD_TOKEN_TABLE

	last_phrase_tokens: EL_TOKENIZED_STRING

	custom_patterns: ARRAY [EL_TEXTUAL_PATTERN]
		do
			create Result.make_empty
		end

end
