note
	description: "[
		Parses locale ID from result of constant prefixed with `English_'
		
			English_name: ZSTRING
				once
					Result := "Dublin"
				end
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_ROUTINE_RESULT_LOCALE_STRING_PARSER

inherit
	EL_ROUTINE_LOCALE_STRING_PARSER
		redefine
			new_pattern
		end

create
	make

feature {NONE} -- Patterns

	pattern_result_assignment: like all_of
		do
			Result := all_of_separated_by (non_breaking_white_space, <<
				all_of (<< string_literal ("Result"), optional (array_index_pattern) >>),
				string_literal (":="),
				quoted_manifest_string (agent on_locale_string)
			>>)
		end

	array_index_pattern: like all_of
		do
			Result := all_of (<<
				non_breaking_white_space, character_literal ('['), integer_constant, character_literal (']')
			>>)
		end

	new_pattern: like one_of
			--
		do
			Result := one_of (<<
				comment, pattern_result_assignment
			>>)
		end

end
