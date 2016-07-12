note
	description: "Summary description for {EL_EIFFEL_PATTERN_FACTORY_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 10:14:40 GMT (Friday 4th March 2016)"
	revision: "5"

class
	EL_EIFFEL_TEXT_PATTERN_FACTORY

inherit
	EL_ZTEXT_PATTERN_FACTORY

feature {NONE} -- Eiffel text patterns

	anchor_type: like all_of
			--
		do
			Result := all_of (<< string_literal ("like"), white_space, c_identifier >>)
		end

	bracketed_expression: like all_of
			--
		do
			Result := all_of (<<
				character_literal ('('),
				zero_or_more (
					one_of (<<
						quoted_manifest_string (Default_action),
						not one_character_from ("()"),
						recurse (agent bracketed_expression, False)
					>>)
				),
				character_literal (')')
			>>)
		end

	class_name: like all_of
			--
		do
			Result := all_of (<< uppercase_letter, one_or_more (class_name_character) >>)
		end

	class_name_character: like one_of_characters
			--
		do
			Result := one_of_characters (<< uppercase_letter, character_literal ('_'), digit >>)
		end

	generic_parameter_list: like all_of
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

	generic_parameter_list_entry: like all_of
			-- Try to match something like INTEGER
			--  " ARRAY [INTEGER]" or "INTEGER"

		do
			Result := all_of (<<
				maybe_white_space,
				one_of (<<
					all_of (<<
						class_name,
						not one_of (<<
							white_space_character,
							character_literal ('[')
						>>)
					>>),
					recurse (agent type_signature, False)
				>>)
			>> )
		end

	return_type_signature_declaration: like all_of
			--
		do
			Result := all_of (<<
				maybe_white_space,
				character_literal (':'),
				maybe_white_space,
				one_of (<< type_signature, anchor_type >>)
			>>)
		end

	type: like all_of
		do
			Result := all_of (<<
				class_name, optional (all_of (<< maybe_white_space, type_list >>))
			>>)
		end

	type_list: like all_of
		do
			Result := all_of (<<
				character_literal ('['),
				maybe_white_space,
				recurse (agent type, False),
				zero_or_more (
					all_of (<< maybe_white_space, character_literal (','),
					maybe_white_space,
					recurse (agent type, False) >>)
				),
				character_literal (']')
			>>)
		end

	type_signature: like all_of
			--
		do
			Result := all_of (<<
				one_of (<<
					class_name,
					uppercase_letter -- A generic parameter
				>>),
				optional (generic_parameter_list)
			>>)
		end

	identifier: like all_of
			--
		do
			Result := all_of (<< letter, zero_or_more (identifier_character) >>)
		end

feature {NONE} -- Numeric constants

	double_constant: like all_of
			--
		do
			Result := all_of (<<
				integer_constant,
				character_literal ('.'),
				one_or_more (digit),
				optional (
					all_of (<<
						one_character_from ("eE"),
						integer_constant
					>>)
				)
			>>)
		end

	integer_constant: like all_of
			--
		do
			Result := all_of (<<
				optional (character_literal ('-')),
				one_or_more (digit)
			>>)
		end

	numeric_constant: like all_of
		do
			Result := all_of (<<
				integer_constant, optional (all_of (<< character_literal ('.'), integer_constant >>) )
			>>)
		end

feature {NONE} -- Eiffel comments

	comment_prefix: EL_LITERAL_TEXT_PATTERN
		do
			Result := string_literal ("--")
		end

	comment: like all_of
			--
		do
			Result := all_of (<< comment_prefix, zero_or_more (not character_literal ('%N')) >>)
		end

feature {NONE} -- Eiffel character manifest

	character_manifest (action: like Default_action ): like all_of
			--
		do
			Result := quoted_character (escaped_character_sequence, action)
		end

feature {NONE} -- Eiffel manifest string

	quoted_manifest_string (match_action: like Default_action): like quoted_string
			--
		do
			Result := quoted_string (escaped_character_sequence, match_action)
		end

	escaped_character_sequence: like all_of
			--
		do
			Result := all_of (<<
				character_literal ('%%'), one_of (<< decimal_character_code, special_character >>)
			>>)
		end

	decimal_character_code: like all_of
		do
			Result :=  all_of (<< character_literal ('/'), digit #occurs (1 |..| 3), character_literal ('/') >>)
		end

	special_character: like one_character_from
		do
			create Result.make ("ABCDFHLNQRSTUV%%'%"()<>")
		end

	unescaped_manifest_string (action_to_process_content: like Default_action): like all_of
			-- String starting with
			--
			--		"[
			-- 		and ending with
			--		]"
		local
			characters_plus_end_quote: like while_not_p1_repeat_p2
			end_delimiter: like all_of
		do
			end_delimiter := all_of (<<
				end_of_line_character,
				maybe_white_space,
				string_literal ("]%"")
			>>)
			characters_plus_end_quote := while_not_p1_repeat_p2 (end_delimiter, any_character)
			Result := all_of (<<
				string_literal ("%"["),
				maybe_non_breaking_white_space,
				one_of (<<
					end_delimiter,
					all_of (<< end_of_line_character, characters_plus_end_quote >>)
				>>)
			>>)
			if action_to_process_content /= Default_action then
				characters_plus_end_quote.set_action_combined_p2 (action_to_process_content)
			end
		end

feature {NONE} -- Parsing actions

	Reserved_word_list: LIST [ZSTRING]
			--
		local
			words, l_word: ZSTRING; case_variations: ARRAYED_LIST [ZSTRING]
		once
			words := Reserved_words
			words.replace_character ('%N', ' ')
			create case_variations.make (20)
			Result := words.split (' ')
			across Result as word loop
				l_word := Result.item
				if l_word.item (1).is_upper then
					case_variations.extend (l_word.as_lower)
				end
			end
			Result.append (case_variations)
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
end
