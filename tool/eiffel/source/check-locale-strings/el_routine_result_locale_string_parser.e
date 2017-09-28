note
	description: "[
		Parses locale ID from result of constant prefixed with `English_'
		
			English_name: ZSTRING
				once
					Result := "Dublin"
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-20 13:11:21 GMT (Sunday 20th August 2017)"
	revision: "1"

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
				non_breaking_white_space, character_literal ('['), integer_constant, character_literal (']')
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
			Result := all_of_separated_by (non_breaking_white_space, <<
				all_of (<< string_literal ("Result"), optional (array_index_pattern) >>),
				string_literal (":="),
				one_of (<<
					pattern_string_array_manifest,
					quoted_manifest_string (agent on_english_string)
				>>)
			>>)
		end

	pattern_string_array_manifest: like all_of
		do
			Result := all_of (<<
				string_literal ("<<"),
				maybe_white_space,
				quoted_manifest_string (agent on_english_string),
				zero_or_more (
					all_of (<<
						character_literal (','), maybe_white_space,
						quoted_manifest_string (agent on_english_string)
					>>)
				),
				maybe_white_space,
				string_literal (">>")
			>>)
		end

feature {NONE} -- Event handling

	on_english_string (matched: EL_STRING_VIEW)
		do
			if quantity_lower <= quantity_upper then
				last_identifier := Quantity_translation.twin
			end
			on_locale_string (matched)
		end

end
