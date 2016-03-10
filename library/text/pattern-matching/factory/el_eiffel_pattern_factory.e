note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EIFFEL_PATTERN_FACTORY

inherit
	EL_TEXTUAL_PATTERN_FACTORY

	EL_MODULE_STRING

feature {NONE} -- Eiffel text patterns

	integer_constant: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				optional (character_literal ('-')),
				one_or_more (digit)
			>>)
		end

	numeric_constant: EL_MATCH_ALL_IN_LIST_TP
		do
			Result := all_of (<<
				integer_constant,
				optional (
					all_of (<<
						character_literal ('.'),
						integer_constant
					>>)
				)
			>>)
		end

	double_constant: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				integer_constant,
				character_literal ('.'),
				one_or_more (digit),
				optional (
					all_of (<<
						one_character_from ("eE"),
						integer_constant
					>>)
				)
			>> )
		end

	identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<< letter, zero_or_more (identifier_character) >>)
		end

	reserved_word: EL_FIRST_MATCH_IN_LIST_TP
			--
		local
			word_pattern_array: ARRAY [EL_MATCH_ALL_IN_LIST_TP]
		do
			create word_pattern_array.make (1, Reserved_word_list.count)
			from Reserved_word_list.start until Reserved_word_list.after loop
				word_pattern_array.put (
					all_of (<<
						string_literal (Reserved_word_list.item),
						not_this (identifier_character)
					>>),
					Reserved_word_list.index
				)
				Reserved_word_list.forth
			end
			create Result.make (word_pattern_array)
		end

	class_identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				one_of_characters (<<
					uppercase_letter,
					character_literal ('_')
				>> ),
				one_or_more (class_identifier_character)
			>> )
		end

	class_identifier_character: EL_FIRST_MATCHING_CHAR_IN_LIST_TP
			--
		do
			Result := one_of_characters (<<
				uppercase_letter,
				digit,
				character_literal ('_')
			>>)
		end

	bracketed_eiffel_expression: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				character_literal ('('),
				zero_or_more (
					one_of_or_else_recursive_pattern (<<
							quoted_eiffel_string (Void),
							not one_character_from ("()")
						>>,
						agent bracketed_eiffel_expression
					)
				),
				character_literal (')')
			>> )
		end

	quoted_eiffel_string (
		 match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := quoted_string_with_escape_sequence (escaped_character_sequence, match_action)
		end

	unescaped_eiffel_string (
		 action_to_process_content: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			-- String starting with
			--
			--		"[
			--
			-- and ending with
			--
			--		]"
		local
			characters_plus_end_quote: EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP
			end_delimiter: EL_MATCH_ALL_IN_LIST_TP
		do
			end_delimiter := all_of (<<
				end_of_line_character,
				maybe_white_space,
				string_literal ("]%"")
			>>)
			characters_plus_end_quote := while_not_pattern_1_repeat_pattern_2 (
				-- pattern 1	pattern 2
				end_delimiter, 	any_character
			)
			Result := all_of ( <<
				string_literal ("%"["),
				maybe_non_breaking_white_space,
				one_of (<<
					end_delimiter,
					all_of (<<
						end_of_line_character,
						characters_plus_end_quote
					>>)
				>>
				)
			>> )
			if attached {PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]} action_to_process_content as action then
				characters_plus_end_quote.set_action_on_combined_repeated_match (action)
			end
		end

	quoted_eiffel_character (
		 agent_to_process_value: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := quoted_character_with_escape_sequence (
				escaped_character_sequence,
				agent_to_process_value
			)
		end

	escaped_character_sequence: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				character_literal ('%%'),
				one_of (<<
					all_of (<<
						character_literal ('/'),
						digit #occurs (1 |..| 3),
						character_literal ('/')
					>>),
					any_character
				>>)
			>>)
		end

	eiffel_comment_marker: EL_LITERAL_TEXTUAL_PATTERN
		do
			Result := string_literal ("--")
		end

	eiffel_comment: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				eiffel_comment_marker,
				zero_or_more (not character_literal ('%N'))
			>>)
		end

	left_hand_class_name_delimiter: EL_MATCH_ANY_CHAR_IN_SET_TP
			--
		do
			Result := one_character_from ("{[:")
			Result.extend_from_other (white_space_character)
		end

	right_hand_class_name_delimiter: EL_MATCH_ANY_CHAR_IN_SET_TP
			--
		do
			Result := one_character_from ("}[]);-")
			Result.extend_from_other (white_space_character)
		end

	parameter_signature_declaration: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				maybe_white_space,
				character_literal ('('),
				repeat_pattern_1_until_pattern_2 (
					not character_literal (')'),
					character_literal (')')
				)
			>>)
			Result.set_name ("parameter_signature_declaration")
			Result.set_debug_to_depth (1)
		end

	return_type_signature_declaration: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				maybe_white_space,
				character_literal (':'),
				maybe_white_space,
				one_of (<<
					eiffel_type_signature,
					anchor_type
				>>)
			>>)
		end

	eiffel_type_signature: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				one_of (<<
					class_identifier,
					uppercase_letter -- A generic parameter
				>>),
				optional (generic_parameter_list)
			>>)
		end

	generic_parameter_list: EL_MATCH_ALL_IN_LIST_TP
			-- Try to match something like for example
			-- [ARRAY [INTEGER], HASH_TABLE [ ARRAY [INTEGER], INTEGER], STRING]
		do
			Result := all_of (<<
				maybe_white_space,
				character_literal ('['),
				generic_parameter_list_entry,
				zero_or_more (
					all_of (<<
						character_literal (','),
						generic_parameter_list_entry
					>>)
				),
				maybe_white_space,
				character_literal (']')
			>>)
		end

	generic_parameter_list_entry: EL_MATCH_ALL_IN_LIST_TP
			-- Try to match something like INTEGER
			--  " ARRAY [INTEGER]" or "INTEGER"

		do
			Result := all_of (<<
				maybe_white_space,
				pattern_1_or_else_recursive_pattern_2 (
					all_of (<<
						class_identifier,
						not one_of (<<
							white_space_character,
							character_literal ('[')
						>>)
					>>),
					agent eiffel_type_signature
				)
			>> )
		end

	anchor_type: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				string_literal ("like"),
				white_space,
				c_identifier
			>>)
		end

	keyword_is: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := whole_word ("is")
			Result.set_name ("keyword_is")
		end

	begin_control_construct_keyword_list: ARRAY [EL_MATCH_ALL_IN_LIST_TP]
			-- Any block that ends with "end"
		do
			Result := <<
				whole_word ("do"),
				whole_word ("deferred"),
				whole_word ("once"),
				whole_word ("external"),
				whole_word ("if"),
				whole_word ("from"),
				whole_word ("inspect"),
				whole_word ("debug"),
				whole_word ("check")
			>>
		end

	compound_instruction_part: EL_MATCH_ALL_IN_LIST_TP
		do
			Result := all_of (<<
				one_of (<<
					white_space,
					eiffel_comment,
					quoted_eiffel_character (Void),
					quoted_eiffel_string (Void),
					c_identifier,
					any_character
				>>),
				not one_of (begin_control_construct_keyword_list)
			>>)


			Result.set_name ("compound_instruction_part")
--			Result.set_debug_to_depth (1)
		end

feature {NONE} -- Parsing actions

	Reserved_word_list: LIST [STRING]
			--
		local
			words, word: STRING
			case_variation_list: LINKED_LIST [STRING]
		once
			words := Reserved_words.string
			String.subst_all_characters (words, '%N', ' ')
			Result := words.split (' ')
			create case_variation_list.make
			from Result.start until Result.after loop
				word := Result.item
				if word.item (1).is_upper then
					case_variation_list.extend (word.as_lower)
				end
				Result.forth
			end
			Result.fill (case_variation_list)
		end

	Reserved_words: STRING =
		-- Eiffel reserved words
	"[
		across agent alias all and as assign attached attribute
		check class convert create Current
		debug deferred do
		else elseif end ensure expanded export external
		False feature from frozen
		if implies indexing inherit inspect invariant is
		like local loop
		not note
		obsolete old once only or
		Precursor
		redefine rename require rescue Result retry
		select separate some
		then True TUPLE
		undefine until
		variant Void
		when
		xor
	]"
end -- class EIFFEL_PATTERNS
