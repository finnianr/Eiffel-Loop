note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_SUBST_VARIABLE_PARSER

inherit
	EL_FILE_PARSER

	EL_TEXTUAL_PATTERN_FACTORY
		redefine
			c_identifier
		end

feature {NONE} -- Token actions

	on_literal_text (matched_text: EL_STRING_VIEW)
			--
		deferred
		end

	on_substitution_variable (matched_text: EL_STRING_VIEW)
			--
		deferred
		end

feature {NONE} -- Implemenation

	subst_variable: EL_TEXTUAL_PATTERN
			--
		do
			Result := one_of (<< variable, terse_variable >> )
		end

	variable: EL_MATCH_ALL_IN_LIST_TP
			-- matches: ${name}
		do
			Result := all_of ( << string_literal ("${"), c_identifier, character_literal ('}') >> )
		end

	terse_variable: EL_MATCH_ALL_IN_LIST_TP
			-- matches: $name
		do
			Result := all_of ( << character_literal ('$'), c_identifier >> )
			Result.set_debug_to_depth (2)
		end

	c_identifier: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := Precursor
			Result.set_action_on_match_begin (agent on_substitution_variable)
		end

	new_pattern: EL_TEXTUAL_PATTERN
			--
		local
			literal_text_pattern: EL_TEXTUAL_PATTERN
		do
			literal_text_pattern := one_or_more (
				not one_character_from ("$")
			)
			literal_text_pattern.set_action_on_match (agent on_literal_text)

			Result := one_or_more (
				one_of ( <<
					literal_text_pattern,
					subst_variable
				>> )
			)
		end

end -- class EL_SUBST_VARIABLE_PARSER

