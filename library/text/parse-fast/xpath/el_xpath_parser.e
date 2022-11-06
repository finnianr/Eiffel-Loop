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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-02 9:40:59 GMT (Wednesday 2nd November 2022)"
	revision: "1"

class
	EL_XPATH_PARSER

inherit
	EL_PARSER
		rename
			make_default as make,
			fully_matched as is_attribute_selector_by_attribute_value
		redefine
			parse, make, source_text
		end

	EL_TEXT_PATTERN_FACTORY

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

	on_attribute_value_predicate (start_index, end_index: INTEGER)
			--
		do
			path_contains_attribute_value_predicate := true
		end

	on_element_name (start_index, end_index: INTEGER)
			-- 'x' in example: AAA/BBB[name='x']/@value
		do
			if attached step_list.last.element_name as name then
				name.wipe_out
				name.append_substring (source_text, start_index, end_index)
			end
		end

	on_selecting_attribute_name (start_index, end_index: INTEGER)
			-- '@name' in example: AAA/BBB[name='x']/@value
		do
			if attached step_list.last.selecting_attribute_name as name then
				name.wipe_out
				name.append_substring (source_text, start_index, end_index)
			end
		end

	on_selecting_attribute_value (start_index, end_index: INTEGER)
			-- 'x' in example: AAA/BBB[name='x']/@value
		do
			if attached step_list.last.selecting_attribute_value as value then
				value.wipe_out
				value.append_substring (source_text, start_index, end_index)
			end
		end

	on_xpath_step (start_index, end_index: INTEGER)
			--
		do
			step_list.extend (create {EL_PARSED_XPATH_STEP}.make (source_text.substring (start_index, end_index)))
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
				quoted_c_lang_string ('%'', Void) |to| agent on_selecting_attribute_value,
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

feature {NONE} -- Internal attributes

	source_text: STRING_8

end