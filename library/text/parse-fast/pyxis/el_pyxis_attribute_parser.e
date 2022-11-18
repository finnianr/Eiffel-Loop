note
	description: "Pyxis attribute parser with deferred implementation of parse events"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-18 17:33:23 GMT (Friday 18th November 2022)"
	revision: "3"

deferred class
	EL_PYXIS_ATTRIBUTE_PARSER

inherit
	EL_PARSER

	EL_TEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

feature {NONE} -- Pattern definitions		

	assignment: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				xml_identifier |to| agent on_name,
				optional_nonbreaking_white_space,
				character_literal ('='),
				optional_nonbreaking_white_space,
				one_of (<<
--					Optimal order for fastest parsing
					core.new_c_quoted_string ('"', agent on_quoted_value),
					core.new_c_quoted_string ('%'', agent on_quoted_value),
					decimal_constant |to| agent on_value,
					xml_identifier |to| agent on_value
				>>)
			>>)
		end

	new_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				assignment,
				zero_or_more (
					all_of (<<
						optional_nonbreaking_white_space,
						character_literal (';'),
						optional_nonbreaking_white_space,
						assignment
					>>)
				)
			>>)
		end

feature {NONE} -- Parse events

	on_name (start_index, end_index: INTEGER)
			--
		deferred
		end

	on_quoted_value (content: STRING_GENERAL)
			--
		deferred
		end

	on_value (start_index, end_index: INTEGER)
			--
		deferred
		end

end