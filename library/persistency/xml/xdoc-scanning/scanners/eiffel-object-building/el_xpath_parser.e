note
	description: "[
		Simple xpath parser that can parse xpaths like the following:
		
		AAA/BBB
		AAA/BBB/@name
		AAA/BBB[@id='x']
		AAA/BBB[@id='x']/@name
		AAA/BBB[id='y']/CCC/text()
		
		<AAA>
			<BBB id="x" name="foo">
			</BBB>
			<BBB id="y" name="bar">
				<CCC>hello</CCC>
			</BBB>
		</AAA>
		
		but cannot parse:
		AAA/BBB[2]/@name
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_XPATH_PARSER

inherit
	EL_FILE_PARSER
		rename
			full_match_succeeded as is_attribute_selector_by_attribute_value
		redefine
			reset
		end

	EL_XML_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	reset
			--
		do
			Precursor
			create step_list.make
			path_contains_attribute_value_predicate := false
		end

feature -- Access

	step_list: LINKED_LIST [EL_XPATH_STEP]

	path_contains_attribute_value_predicate: BOOLEAN

feature {NONE} -- Token actions

	on_xpath_step (matched_text: EL_STRING_VIEW)
			--
		do
			step_list.extend (create {EL_XPATH_STEP}.make (matched_text))
		end

	on_selecting_attribute_name (matched_text: EL_STRING_VIEW)
			-- '@name' in example: AAA/BBB[name='x']/@value
		do
			step_list.last.set_selecting_attribute_name (matched_text)
		end

	on_selecting_attribute_value (matched_text: EL_STRING_VIEW)
			-- 'x' in example: AAA/BBB[name='x']/@value
		do
			step_list.last.set_selecting_attribute_value (matched_text)
		end

	on_element_name (matched_text: EL_STRING_VIEW)
			-- 'x' in example: AAA/BBB[name='x']/@value
		do
			step_list.last.set_element_name (matched_text)
		end

	on_attribute_value_predicate (matched_text: EL_STRING_VIEW)
			--
		do
			path_contains_attribute_value_predicate := true
		end

feature {NONE} -- Grammar

	single_quote_literal: EL_LITERAL_CHAR_TP
			--
		do
			create Result.make ({ASCII}.Singlequote.to_natural_32)
		end

	attribute_name_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<< character_literal ('@'), xml_identifier >>)
		end

	attribute_value_predicate_pattern: EL_MATCH_ALL_IN_LIST_TP
			-- Expression like the following
			--	[@x='y']
		local
			quoted_string_contents_including_end_quote: EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
		do
			create quoted_string_contents_including_end_quote.make (
				single_quote_literal, not single_quote_literal
			)
			quoted_string_contents_including_end_quote.set_action_on_combined_repeated_match (
				agent on_selecting_attribute_value
			)
			Result := all_of ( <<
				character_literal ('['),
				attribute_name_pattern |to| agent on_selecting_attribute_name,
				string_literal ("='"),
				quoted_string_contents_including_end_quote,
				character_literal (']')
			>> )
			Result.set_action_on_match_end (agent on_attribute_value_predicate)
		end

	xpath_element_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				xml_identifier |to| agent on_element_name,
				optional (attribute_value_predicate_pattern)
			>>)
			Result.set_name ("XP-Element")
		end

	new_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				zero_or_more (
					all_of (<<
						xpath_element_pattern |to| agent on_xpath_step,
						character_literal ('/')
					>>)
				),
				one_of (<<
					string_literal ("text()"),
					attribute_name_pattern,
					xpath_element_pattern
				>>) |to| agent on_xpath_step

			>>)
--			Result.set_debug_to_depth (4)
		end

end
