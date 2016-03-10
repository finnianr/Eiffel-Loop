note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_XML_HTML_PATTERN_FACTORY

inherit
	EL_TEXTUAL_PATTERN_FACTORY

feature {NONE} -- Element patterns

	comment: EL_MATCH_ALL_IN_LIST_TP
			--
		local
			comment_text: EL_MATCH_TP1_ON_CONDITION_TP2_MATCH_TP
		do
			comment_text := while_not_pattern_1_repeat_pattern_2 (
				string_literal ("-->"),
				any_character
			)
			comment_text.set_action_on_combined_repeated_match (comment_action)
			Result := all_of ( <<
				string_literal ("<!--"),
				comment_text
			>> )
--			Result.set_name ("comment")
		end

	attribute_quoted_string_value (
		agent_to_process_value: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
	): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := quoted_string_with_escape_sequence (
				all_of (<<
					character_literal ('&') ,
					letter #occurs (1 |..| 4),
					character_literal (';')
				>>),
				agent_to_process_value
			)
--			Result.set_name ("attribute_quoted_string_value")
		end

feature {NONE} -- Parsing actions

	comment_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			-- Void return value means do nothing
		do
		end

	tag_name_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			-- Void return value means do nothing
		do
		end

	closing_tag_name_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			-- Void return value means do nothing
		do
		end

end -- class EL_XML_HTML_TEXTUAL_PATTERNS

