note
	description: "Summary description for {SEARCH_TERM_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-13 15:41:17 GMT (Wednesday 13th January 2016)"
	revision: "4"

class
	EL_SEARCH_TERM_PARSER

inherit
	EL_FILE_PARSER
		rename
			make_default as make,
			parse as compile_criteria,
			set_source_text as set_search_terms
		export
			{NONE} all
			{ANY} set_search_terms
		redefine
			make, reset, set_search_terms, source_text
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY
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
			Precursor
		end

feature {NONE} -- Initialization

	reset
			--
		do
			criteria.wipe_out
			match_words.wipe_out
			invalid_wildcard := False
			Precursor
		end

feature -- Access

	criteria: ARRAYED_LIST [EL_SEARCH_TERM]

	match_words: ARRAYED_LIST [EL_TOKENIZED_STRING]

feature -- Element Change

 	set_search_terms (search_terms: ZSTRING)
 			--
 		require else
 			no_leading_or_trailing_white_space: search_terms.leading_white_space + search_terms.trailing_white_space = 0
 		do
 			Precursor (search_terms)
			compile_criteria
 		end

	set_word_table (a_word_table: like word_token_table)
			--
		do
			word_token_table := a_word_table
		end

feature -- Status query

	invalid_wildcard: BOOLEAN

	is_valid: BOOLEAN
		do
			Result := fully_matched and not invalid_wildcard
		end

feature {NONE} -- Text patterns

	default_word: like all_of
			--
		do
			Result := all_of (<< one_or_more (alphanumeric), optional (character_literal ('*')) >>) |to| agent on_word_or_phrase
		end

	either_search_term: like all_of
			--
		do
			Result := all_of_separated_by (non_breaking_white_space, <<
				positive_or_negated_search_term, string_literal ("OR"), recurse (agent search_term, True)
			>>)
			Result.set_action_last (agent on_either_search_term)
		end

	new_pattern: like all_of
			--
		do
			Result := all_of (<<
				search_term, zero_or_more (all_of (<< non_breaking_white_space, search_term >>) )
			>>)
		end

	positive_or_negated_search_term: like all_of
			--
		do
			Result := all_of (<<
				optional (character_literal ('-') |to| agent on_hypen_prefix (?, True)),
				positive_search_term
			>>)
			Result.set_action_first (agent on_hypen_prefix (?, False))
			Result.set_action_last (agent on_positive_or_negated_search_term)
		end

	positive_search_term: EL_FIRST_MATCH_IN_LIST_TP
		do
			create Result.make (custom_patterns)
			Result.extend (quoted_phrase)
			Result.extend (default_word)
		end

	quoted_phrase: like quoted_string
			--
		do
			Result := quoted_string (string_literal ("\%""), agent on_word_or_phrase)
		end

	search_term: like one_of
			--
		do
			Result := one_of (<< either_search_term, positive_or_negated_search_term >>)
		end

feature {NONE} -- Match actions

	on_either_search_term (matched: EL_STRING_VIEW)
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

	on_hypen_prefix (matched: EL_STRING_VIEW; value: BOOLEAN)
		do
			has_hypen_prefix := value
		end

	on_positive_or_negated_search_term (matched: EL_STRING_VIEW)
		do
			if has_hypen_prefix then
				criteria.last.set_negative
				if attached {EL_CONTAINS_WORDS_SEARCH_TERM} criteria.last as last then
					match_words.finish
					match_words.remove
				end
			end
		end

	on_word_or_phrase (matched: EL_STRING_VIEW)
			--
		local
			word_tokens: EL_TOKENIZED_STRING; text: ZSTRING
		do
			text := matched
			if not text.is_empty and then text [text.count] = '*' then
				text.remove_tail (1); add_wildcard_term (text)
			else
				create word_tokens.make_from_string (word_token_table, text)
				criteria.extend (create {EL_CONTAINS_WORDS_SEARCH_TERM}.make (word_tokens))
				match_words.extend (word_tokens)
			end
		end

feature {NONE} -- Implementation

	add_one_of_words_search_term_criteria (phrase_stem_words: EL_TOKENIZED_STRING; word_stem: ZSTRING)
		local
			word_list: like word_token_table.words
			potential_match_word, word_variations: EL_TOKENIZED_STRING
			end_word_token: NATURAL; word_stem_lower: ZSTRING
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

	add_wildcard_term (text: ZSTRING)
		local
			words: EL_ZSTRING_LIST; word_tokens: EL_TOKENIZED_STRING
		do
			create words.make_with_words (text)
			words.prune_all_empty
			if words.last.count < 3 then
				invalid_wildcard := True
			else
				if words.count = 1 then
					create word_tokens.make (word_token_table, 0)
				else
					create word_tokens.make_from_string (word_token_table, words.subchain (1, words.count - 1).joined_words)
				end
				add_one_of_words_search_term_criteria (word_tokens, words.last)
			end
		end

	custom_patterns: ARRAY [EL_TEXT_PATTERN]
		do
			create Result.make_empty
		end

	has_hypen_prefix: BOOLEAN

	source_text: ZSTRING

	word_token_table: EL_WORD_TOKEN_TABLE

end
