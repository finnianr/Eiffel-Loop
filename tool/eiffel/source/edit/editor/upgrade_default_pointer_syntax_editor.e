note
	description: "[
		Change syntax of default_pointers references: 
			ptr /= default_pointer TO is_attached (ptr)
			ptr = default_pointer TO not is_attached (ptr)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 8:29:36 GMT (Tuesday 27th August 2024)"
	revision: "9"

class
	UPGRADE_DEFAULT_POINTER_SYNTAX_EDITOR


inherit
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create variable_name.make_empty
		end

feature {NONE} -- Pattern definitions

	search_patterns: ARRAYED_LIST [TP_PATTERN]
		do
			create Result.make_from_array (<<
				pointer_comparison,
				unmatched_identifier_plus_white_space -- skips to next identifier
			>>)
		end

	pointer_comparison: like all_of
			--
		do
			Result := all_of_separated_by (white_space, <<
				identifier |to| agent on_variable_name,
				one_of (<<
					string_literal ("/="),
					string_literal ("=")
				>>) |to| agent on_comparison_operator,
				default_pointer_name
			>> )
			Result.set_action_last (agent on_pointer_comparison)
		end

	default_pointer_name: like all_of
			--
		do
			Result := all_of ( << one_character_from ("Dd"), string_literal ("efault_pointer")>> )
		end

	one_or_two_spaces: TP_COUNT_WITHIN_BOUNDS
		do
			Result := character_literal (' ') #occurs (1 |..| 2)
		end

feature {NONE} -- Parsing actions

	on_variable_name (start_index, end_index: INTEGER)
			--
		do
			variable_name := source_substring (start_index, end_index, False)
		end

	on_pointer_comparison (start_index, end_index: INTEGER)
			--
		do
			if is_equal_comparison then
				put_string (Template_unattached #$ [variable_name])
			else
				put_string (Template_attached #$ [variable_name])
			end
		end

	on_comparison_operator (start_index, end_index: INTEGER)
			--
		do
			is_equal_comparison := source_text.item_8 (start_index) = '='
		end

feature {NONE} -- Implementation

	variable_name: STRING

	is_equal_comparison: BOOLEAN

	Template_attached: ZSTRING
		do
			Result := "is_attached (%S)"
		end

	Template_unattached: ZSTRING
		do
			Result := "not is_attached (%S)"
		end
end