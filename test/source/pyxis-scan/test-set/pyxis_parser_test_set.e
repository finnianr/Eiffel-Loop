note
	description: "Pyxis parser test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-09 10:32:14 GMT (Saturday 9th January 2021)"
	revision: "5"

class
	PYXIS_PARSER_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_PYXIS_TEXT_PATTERN_FACTORY
		export
			{NONE} all
		undefine
			default_create
		end

	PYXIS_ATTRIBUTE_PARSER_TEST_DATA
		export
			{NONE} all
		undefine
			default_create
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("find_all", agent test_find_all)
			eval.call ("pyxis_parser", agent test_pyxis_parser)
			eval.call ("xpath_parser", agent test_xpath_parser)
		end

feature -- Tests

	test_find_all
		note
			testing: "covers/{EL_TEXT_PATTERN}.find_all"
		local
			pattern: EL_TEXT_PATTERN; comma_separated_list: STRING
		do
			create comma_separated_list.make_empty
			pattern := pyxis_assignment (comma_separated_list)
			pattern.find_all (Attributes_source_line, agent on_unmatched_text (?, comma_separated_list))
			assert ("find_all OK", Attributes_comma_separated_values ~ comma_separated_list)
		end

	test_pyxis_parser
		note
			testing: "covers/{EL_PYXIS_ATTRIBUTE_PARSER}.parse"
		local
			parser: EL_PYXIS_ATTRIBUTE_PARSER
			table: like Attribute_table; name: STRING
			attribute_list: EL_ELEMENT_ATTRIBUTE_LIST
			l_attribute: EL_ELEMENT_ATTRIBUTE_NODE_STRING
		do
			create attribute_list.make
			create parser.make (attribute_list)
			parser.set_source_text (Attributes_source_line)
			parser.parse
			create table.make_equal (5)
			across attribute_list as list loop
				l_attribute := list.item
				name := l_attribute.name
				if l_attribute.is_integer then
					table [name] := l_attribute.to_integer
				elseif l_attribute.is_double then
					table [name] := l_attribute.to_double
				elseif l_attribute.is_boolean then
					table [name] := l_attribute.to_boolean
				else
					table [name] := l_attribute.to_string_8
				end
			end
			assert ("pyxis_parser OK", table ~ Attribute_table)
		end

	test_xpath_parser
		note
			testing: "covers/{EL_XPATH_PARSER}.parse"
		local
			parser: EL_XPATH_PARSER; steps: LIST [STRING]; parsed_step: EL_PARSED_XPATH_STEP
			index_of_at, index_of_equal: INTEGER
		do
			create parser.make
			across Xpaths.split ('%N') as xpath loop
				steps := xpath.item.split ('/')
				parser.set_source_text (xpath.item)
				parser.parse
				across steps as step loop
					parsed_step := parser.step_list.i_th (step.cursor_index)
					assert ("parser OK", parsed_step.step ~ step.item)
					index_of_at := step.item.index_of ('@', 1)
					if index_of_at > 0 then
						index_of_equal := step.item.index_of ('=', 1)
						assert ("parser OK",
							parsed_step.selecting_attribute_name ~ step.item.substring (index_of_at, index_of_equal - 1)
						)
					end
				end
			end
		end

feature {NONE} -- Patterns

	pyxis_assignment (comma_separated_list: STRING): like all_of
			--
		do
			Result := all_of ( <<
				character_literal ('='),
				maybe_non_breaking_white_space,
				one_of (<<
					xml_identifier |to| agent on_value (?, comma_separated_list),
					numeric_constant |to| agent on_value (?, comma_separated_list),
					quoted_string (double_quote_escape_sequence, agent on_quoted_value (?, True, comma_separated_list)),
					single_quoted_string (single_quote_escape_sequence, agent on_quoted_value (?, False, comma_separated_list))
				>>)
			>> )
		end

feature {NONE} -- Parse events handlers

	on_quoted_value (matched: EL_STRING_VIEW; is_double_quote: BOOLEAN; comma_separated_list: STRING)
		local
			quote_count: INTEGER; s: EL_STRING_8_ROUTINES
		do
			if is_double_quote then
				quote_count := 2
			else
				quote_count := 1
			end
			if not comma_separated_list.is_empty then
				comma_separated_list.append_character (',')
			end
			comma_separated_list.append_string (s.quoted (matched.to_string_8, quote_count))
		end

	on_unmatched_text (matched: EL_STRING_VIEW; source: STRING)
		do
			source.append_string (matched.to_string_8)
		end

	on_value (matched: EL_STRING_VIEW; comma_separated_list: STRING)
		do
			if not comma_separated_list.is_empty then
				comma_separated_list.append_character (',')
			end
			comma_separated_list.append_string (matched.to_string_8)
		end

feature {NONE} -- Constants

	Xpaths: STRING = "[
		head/meta[@name='title']/@content
		body/seq
		@id
		audio
	]"

end