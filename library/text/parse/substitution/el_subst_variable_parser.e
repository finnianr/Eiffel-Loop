note
	description: "Subst variable parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

deferred class
	EL_SUBST_VARIABLE_PARSER

inherit
	EL_PARSER

	TP_C_LANGUAGE_FACTORY

feature {NONE} -- Token actions

	on_literal_text (start_index, end_index: INTEGER)
			--
		deferred
		end

	on_substitution_variable (start_index, end_index: INTEGER)
			--
		deferred
		end

feature {NONE} -- Implemenation

	subst_variable: like one_of
			--
		do
			Result := one_of (<< variable, terse_variable >> )
		end

	variable: like all_of
			-- matches: ${name}
		do
			Result := all_of (<<
				string_literal ("${"),
				identifier |to| agent on_substitution_variable,
				character_literal ('}')
			>>)
		end

	terse_variable: like all_of
			-- matches: $name
		do
			Result := all_of (<<
				character_literal ('$'),
				identifier |to| agent on_substitution_variable
			>>)
		end

	new_pattern: TP_PATTERN
			--
		local
			literal_text_pattern: TP_PATTERN
		do
			literal_text_pattern := one_or_more (not one_character_from ("$"))
			literal_text_pattern.set_action (agent on_literal_text)

			Result := one_or_more (one_of (<< literal_text_pattern, subst_variable >>))
		end

end