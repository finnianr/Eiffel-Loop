note
	description: "Summary description for {EL_XML_PATTERN_FACTORY_OBSOLETE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_EXPERIMENTAL_XML_PARSER

obsolete
	"Failed experiment. Use something else instead"

inherit
	EL_XML_PATTERN_FACTORY

feature {NONE} -- XML element patterns

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

	attribute_name: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := xml_identifier |to| attribute_name_action
			Result.set_name ("attribute_name")
		end

	named_element_attribute (
		name: STRING;
		agent_to_process_value: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				white_space,
				string_literal (name),
				maybe_white_space,
				character_literal ('='),
				maybe_white_space,
				attribute_quoted_string_value (agent_to_process_value)
			>> )
		end

	doctype_declaration: EL_MATCH_ALL_IN_LIST_TP
			-- eg. <?xml version="1.0" encoding="UTF-8"?>
		do
			Result := all_of ( <<
				string_literal ("<!DOCTYPE"),
				zero_or_more (
					all_of ( <<
						white_space,
						one_of (<<
							xml_identifier |to| doctype_declaration_parameter_action,
							attribute_quoted_string_value (
								doctype_declaration_quoted_string_value_action
							)
						>>)
					>>)
				),
				maybe_white_space,
				character_literal ('>')
			>>) |to| doctype_declaration_action
		end

	cdata_section: EL_MATCH_ALL_IN_LIST_TP
			--
		local
			character_data: EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP
		do
			character_data := while_not_pattern_1_repeat_pattern_2 (
				string_literal ("]]>"),
				any_character
			)
			character_data.set_action_on_combined_repeated_match (cdata_section_action)
			Result := all_of ( <<
				string_literal ("<![CDATA["),
				character_data
			>> )
			Result.set_name ("cdata_section")
		end

	element (
		tag_name: STRING; attributes: EL_MATCH_ZERO_OR_MORE_TIMES_TP; nested_elements: ARRAY [EL_MATCH_ALL_IN_LIST_TP]
	): EL_XML_ELEMENT_PATTERN

	do
		create Result.make (tag_name, attributes, nested_elements)
	end

	empty_element (tag_name: STRING; attributes: EL_MATCH_ZERO_OR_MORE_TIMES_TP): EL_XML_EMPTY_ELEMENT_PATTERN

	do
		create Result.make (tag_name, attributes)
	end

	element_text: EL_MATCH_ONE_OR_MORE_TIMES_TP
			--
		do
			Result := one_or_more (
				not character_literal ('<')
			) |to| element_text_action
			Result.set_name ("text_words")
		end

	element_attribute: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				white_space,
				attribute_name,
				maybe_white_space,
				character_literal ('=') |to| equal_sign_action,
				maybe_white_space,
				attribute_quoted_string_value (attribute_value_action)
			>> )
		end

	processing_instruction_attribute: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				white_space,
				attribute_name |to| processing_instruction_attribute_name_action,
				maybe_white_space,
				character_literal ('='),
				maybe_white_space,
				attribute_quoted_string_value (processing_instruction_quoted_string_action)
			>> )
		end

	processing_instruction: EL_MATCH_ALL_IN_LIST_TP
			-- eg. <?xml version="1.0" encoding="UTF-8"?>
		do
			Result := all_of ( <<
				string_literal ("<?"),
				xml_identifier |to| processing_instruction_name_action,
				zero_or_more (
					processing_instruction_attribute
				),
				maybe_white_space,
				string_literal ("?>")
			>> )
		end

feature {NONE} -- Parsing action assignments

	attribute_name_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	attribute_value_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	cdata_section_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	element_close_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	equal_sign_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	element_open_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	xml_identifier_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	empty_element_close_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	element_text_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	doctype_declaration_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	doctype_declaration_parameter_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	doctype_declaration_quoted_string_value_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	processing_instruction_attribute_name_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	processing_instruction_name_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

	processing_instruction_quoted_string_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--
		do
		end

end
