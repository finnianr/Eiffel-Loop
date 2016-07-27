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
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 16:13:00 GMT (Thursday 7th July 2016)"
	revision: "5"

class
	EL_XPATH_PARSER

inherit
	EL_PARSER
		rename
			make_default as make,
			fully_matched as is_attribute_selector_by_attribute_value
		redefine
			parse, make
		end

	EL_XML_TEXT_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create step_list.make (5)
		end

feature -- Basic operations

	parse
			--
		do
			step_list.wipe_out
			path_contains_attribute_value_predicate := false
			Precursor
		end

feature -- Access

	path_contains_attribute_value_predicate: BOOLEAN

	step_list: ARRAYED_LIST [EL_PARSED_XPATH_STEP]

feature {NONE} -- Token actions

	on_attribute_value_predicate (matched_text: EL_STRING_VIEW)
			--
		do
			path_contains_attribute_value_predicate := true
		end

	on_element_name (matched_text: EL_STRING_VIEW)
			-- 'x' in example: AAA/BBB[name='x']/@value
		do
			step_list.last.set_element_name (matched_text)
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

	on_xpath_step (matched_text: EL_STRING_VIEW)
			--
		do
			step_list.extend (create {EL_PARSED_XPATH_STEP}.make (matched_text))
		end

feature {NONE} -- Grammar

	attribute_name_pattern: like all_of
			--
		do
			Result := all_of (<< character_literal ('@'), xml_identifier >>)
		end

	attribute_value_predicate_pattern: like all_of
			-- Expression like the following
			--	[@x='y']
		do
			Result := all_of ( <<
				character_literal ('['),
				attribute_name_pattern |to| agent on_selecting_attribute_name,
				string_literal ("="),
				single_quoted_string (single_quote, agent on_selecting_attribute_value),
				character_literal (']')
			>> )
			Result.set_action_last (agent on_attribute_value_predicate)
		end

	new_pattern: like all_of
			--
		do
			Result := all_of (<<
				zero_or_more (
					all_of (<<
						xpath_element_pattern |to| agent on_xpath_step,
						character_literal ('/')
					>>)
				),
				one_of (<< string_literal ("text()"), attribute_name_pattern, xpath_element_pattern >>) |to| agent on_xpath_step
			>>)
		end

	xpath_element_pattern: like all_of
			--
		do
			Result := all_of (<<
				xml_identifier |to| agent on_element_name,
				optional (attribute_value_predicate_pattern)
			>>)
		end

end