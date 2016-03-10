note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_C_PATTERN_FACTORY

inherit
	EL_TEXTUAL_PATTERN_FACTORY

feature {NONE} -- C code patterns

	comment: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				string_literal ("/*"),
				while_not_pattern_1_repeat_pattern_2 (
					string_literal ("*/"), any_character
				)
			>>)
		end

	one_line_comment: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				string_literal ("//"),
				while_not_pattern_1_repeat_pattern_2 (
					end_of_line_character, any_character
				)
			>>)
		end

	quoted_c_string (
		 match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := quoted_string_with_escape_sequence (
				escaped_character_sequence,
				match_action
			)
		end

	quoted_c_character (
		 match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				character_literal ('''),
				one_of (<<
					escaped_character_sequence,
					any_character
				>>),
				character_literal (''')
			>>)
			if match_action /= Void then
				Result.i_th (2).set_action_on_match (match_action)
			end
		end

	escaped_character_sequence: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				character_literal ('\'),
				one_of (<<
					one_character_from ("\'%"?abfnrt"),
					octal_number,
					hexadecimal_number
				>>)
			>>)
		end

	octal_number: EL_MATCH_ONE_OR_MORE_TIMES_TP
			--
		do
			Result := one_or_more (character_in_range ('0', '7'))
		end

	hexadecimal_number: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				one_character_from ("xX"),
				one_or_more (
					one_of (<<
						character_in_range ('0', '9'),
						character_in_range ('A', 'F'),
						character_in_range ('a', 'f')
					>>)
				)
			>>)
		end

	statement_block: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				character_literal ('{'),
				zero_or_more (
					one_of_or_else_recursive_pattern (<<
							comment,
							one_line_comment,
							quoted_c_string (Void),
							quoted_c_character (Void),
							not one_character_from ("{}")
						>>,
						agent statement_block
					)
				),
				character_literal ('}')
			>> )
		end

end
