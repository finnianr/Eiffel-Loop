note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 11:43:22 GMT (Friday 18th December 2015)"
	revision: "4"

class
	EL_C_PATTERN_FACTORY

inherit
	EL_ZTEXT_PATTERN_FACTORY

feature {NONE} -- C code patterns

	comment: like all_of
			--
		do
			Result := all_of (<<
				string_literal ("/*"),
				while_not_p1_repeat_p2 (string_literal ("*/"), any_character)
			>>)
		end

	one_line_comment: like all_of
			--
		do
			Result := all_of (<<
				string_literal ("//"),
				while_not_p1_repeat_p2 (end_of_line_character, any_character)
			>>)
		end

	quoted_c_string (match_action: like Default_action): like quoted_string
			--
		do
			Result := quoted_string (escaped_character_sequence, match_action)
		end

	quoted_c_character (match_action: like Default_action): like all_of
			--
		do
			Result := all_of (<<
				character_literal ('''),
				one_of (<< escaped_character_sequence, any_character >>),
				character_literal (''')
			>>)
			Result.i_th (2).set_action (match_action)
		end

	escaped_character_sequence: like all_of
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

	octal_number: like one_or_more
			--
		do
			Result := one_or_more (character_in_range ('0', '7'))
		end

	hexadecimal_number: like all_of
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

	statement_block: like all_of
			--
		do
			Result := all_of ( <<
				character_literal ('{'),
				zero_or_more (
					one_of (<<
							comment,
							one_line_comment,
							quoted_c_string (Default_action),
							quoted_c_character (Default_action),
							not one_character_from ("{}"),
							recurse (agent statement_block, False)
					>>)
				),
				character_literal ('}')
			>> )
		end

end
