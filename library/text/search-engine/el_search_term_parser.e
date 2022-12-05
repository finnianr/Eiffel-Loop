note
	description: "Search term parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:27:28 GMT (Monday 5th December 2022)"
	revision: "20"

class
	EL_SEARCH_TERM_PARSER [G -> EL_WORD_SEARCHABLE]

inherit
	EL_FILE_PARSER
		rename
			make_default as make,
			parse as compile_conditions,
			source_text as search_terms,
			set_source_text as set_search_terms
		export
			{NONE} all
		redefine
			make, reset
		end

	TP_FACTORY
		export
			{NONE} all
		end

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create word_token_table.make (1)
			create condition_list.make (10)
			create match_words.make (5)
			Precursor
		end

feature {NONE} -- Initialization

	reset
			--
		do
			condition_list.wipe_out
			match_words.wipe_out
			invalid_wildcard := False
			Precursor
		end

feature -- Access

	match_words: ARRAYED_LIST [EL_WORD_TOKEN_LIST]

	query_condition: EL_QUERY_CONDITION [G]
		do
			inspect condition_list.count
				when 0 then
					create {EL_ANY_QUERY_CONDITION [G]} Result
				when 1 then
					Result := condition_list.first
			else
				create {EL_ALL_OF_QUERY_CONDITION [G]} Result.make (condition_list.to_array)
			end
		end

feature -- Element Change

 	set_query_condition (a_search_terms: ZSTRING; a_word_table: like word_token_table)
 			--
 		do
			word_token_table := a_word_table
 			set_search_terms (a_search_terms.stripped)
			compile_conditions
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
			Result := all_of (<<
				one_or_more (alphanumeric), optional (character_literal ('*'))
			>>) |to| agent on_word_or_phrase_substring
		end

	either_search_term: like all_of
			--
		do
			Result := all_of_separated_by (nonbreaking_white_space, <<
				positive_or_negated_search_term, string_literal ("OR"), recurse (agent search_term, 1)
			>>)
			Result.set_action_last (agent on_either_search_term)
		end

	new_pattern: like all_of
			--
		do
			Result := all_of (<<
				search_term, zero_or_more (all_of (<< nonbreaking_white_space, search_term >>) )
			>>)
		end

	positive_or_negated_search_term: like all_of
			--
		do
			Result := all_of (<<
				optional (character_literal ('-') |to| agent on_hypen_prefix (?, ?, True)),
				positive_search_term
			>>)
			Result.set_action_first (agent on_hypen_prefix (?, ?, False))
			Result.set_action_last (agent on_positive_or_negated_search_term)
		end

	positive_search_term: like one_of
		do
			create Result.make (custom_patterns)
			Result.extend (quoted_phrase)
			Result.extend (default_word)
		end

	quoted_phrase: like quoted_string
			--
		do
			Result := quoted_string ('"', agent on_word_or_phrase)
		end

	search_term: like one_of
			--
		do
			Result := one_of (<< either_search_term, positive_or_negated_search_term >>)
		end

feature {NONE} -- Match actions

	on_either_search_term (start_index, end_index: INTEGER)
			--
		require
			at_least_two_condition_operands: condition_list.count >= 2
		local
			left: EL_QUERY_CONDITION [G]
		do
			condition_list.finish; condition_list.back
			left := condition_list.item -- second last item
			condition_list.remove
			condition_list.replace (left or condition_list.item)
		end

	on_hypen_prefix (start_index, end_index: INTEGER; value: BOOLEAN)
		do
			has_hypen_prefix := value
		end

	on_positive_or_negated_search_term (start_index, end_index: INTEGER)
		do
			if has_hypen_prefix and then not condition_list.is_empty then
				condition_list.finish
				if attached {EL_CONTAINS_WORDS_CONDITION [G]} condition_list.item then
					match_words.finish
					match_words.remove
				end
				condition_list.replace (not condition_list.item)
			end
		end

	on_word_or_phrase_substring (start_index, end_index: INTEGER)
			--
		do
			on_word_or_phrase (source_substring (start_index, end_index, True))
		end

	on_word_or_phrase (general: STRING_GENERAL)
			--
		local
			word_tokens: EL_WORD_TOKEN_LIST; text: ZSTRING
			s: EL_ZSTRING_ROUTINES
		do
			text := s.as_zstring (general)
			if not text.is_empty and then text [text.count] = '*' then
				text.remove_tail (1); add_wildcard_term (text)
			else
				word_tokens := word_token_table.paragraph_tokens (text)
				condition_list.extend (create {EL_CONTAINS_WORDS_CONDITION [G]}.make (word_tokens))
				match_words.extend (word_tokens)
			end
		end

feature {NONE} -- Implementation

	add_one_of_words_search_term_condition (phrase_stem_words: EL_WORD_TOKEN_LIST; word_stem: ZSTRING)
		local
			word_list: like word_token_table.word_list
			potential_match_word, word_variations: EL_WORD_TOKEN_LIST
			end_word_token: NATURAL; word_stem_lower: ZSTRING
		do
			word_stem_lower := word_stem.as_lower
			create word_variations.make (20)
			word_list := word_token_table.word_list
			from word_list.start until word_list.after loop
				if word_list.item.starts_with_zstring (word_stem_lower) then
					end_word_token := word_list.index.to_natural_32
					word_variations.append_code (end_word_token)

					create potential_match_word.make (phrase_stem_words.count + 1)
					potential_match_word.append (phrase_stem_words)
					potential_match_word.append_code (end_word_token)
					match_words.extend (potential_match_word)
				end
				word_list.forth
			end
			condition_list.extend (create {EL_ONE_OF_WORDS_CONDITION [G]}.make (phrase_stem_words, word_variations))
		end

	add_wildcard_term (text: ZSTRING)
		local
			words: EL_ZSTRING_LIST; word_tokens: EL_WORD_TOKEN_LIST
		do
			create words.make_word_split (text)
			words.prune_all_empty
			if words.last.count < 3 then
				invalid_wildcard := True
			else
				if words.count = 1 then
					create word_tokens.make (0)
				else
					word_tokens := word_token_table.paragraph_tokens (words.subchain (1, words.count - 1).joined_words)
				end
				add_one_of_words_search_term_condition (word_tokens, words.last)
			end
		end

	custom_patterns: ARRAY [TP_PATTERN]
		do
			create Result.make_empty
		end

feature {NONE} -- Internal attributes

	condition_list: ARRAYED_LIST [EL_QUERY_CONDITION [G]]

	has_hypen_prefix: BOOLEAN

	word_token_table: EL_WORD_TOKEN_TABLE

end