note
	description: "[
		Parses locale ID from result of constant prefixed with `English_'
		
			English_name: ZSTRING
				once
					Result := "Dublin"
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 17:24:05 GMT (Wednesday 16th November 2022)"
	revision: "3"

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

	array_index_pattern: like all_of
		do
			Result := all_of (<<
				nonbreaking_white_space, character_literal ('['), signed_integer, character_literal (']')
			>>)
		end

	new_pattern: like one_of
			--
		do
			Result := one_of (<<
				pattern_quantity_translation_hint, comment,
				pattern_result_assignment
			>>)
		end

	pattern_result_assignment: like all_of
		do
			Result := all_of_separated_by (nonbreaking_white_space, <<
				all_of (<< string_literal ("Result"), optional (array_index_pattern) >>),
				string_literal (":="),
				one_of (<<
					pattern_string_array_manifest,
					quoted_string (Void) |to| agent on_english_string
				>>)
			>>)
		end

	pattern_string_array_manifest: like all_of
		do
			Result := all_of (<<
				string_literal ("<<"),
				optional_white_space,
				quoted_string (Void) |to| agent on_english_string,
				zero_or_more (
					all_of (<<
						character_literal (','), optional_white_space,
						quoted_string (Void) |to| agent on_english_string
					>>)
				),
				optional_white_space,
				string_literal (">>")
			>>)
		end

feature {NONE} -- Event handling

	on_english_string (start_index, end_index: INTEGER)
		do
			if quantity_lower <= quantity_upper then
				last_identifier := Quantity_translation.twin
			end
			on_locale_string (start_index, end_index)
		end

end