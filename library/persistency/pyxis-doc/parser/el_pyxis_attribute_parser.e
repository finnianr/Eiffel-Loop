note
	description: "Pyxis attribute parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-04 11:54:22 GMT (Monday 4th January 2021)"
	revision: "7"

class
	EL_PYXIS_ATTRIBUTE_PARSER

inherit
	EL_PARSER

	EL_PYXIS_ZTEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

	EL_PYXIS_UNESCAPE_CONSTANTS

	EL_MODULE_STRING_32

	EL_DOCUMENT_CLIENT

create
	make

feature {NONE} -- Initialization

	make (a_attribute_list: like attribute_list)
		do
			attribute_list := a_attribute_list
			make_default
		end

feature {NONE} -- Pattern definitions		

	assignment: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				attribute_identifier |to| agent on_name,
				maybe_non_breaking_white_space,
				character_literal ('='),
				maybe_non_breaking_white_space,
				one_of (<<
					xml_identifier |to| agent on_value,
					numeric_constant |to| agent on_value,
					quoted_string (double_quote_escape_sequence, agent on_quoted_value (?, True)),
					single_quoted_string (single_quote_escape_sequence, agent on_quoted_value (?, False))
				>>)
			>> )
		end

	new_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				assignment,
				zero_or_more (
					all_of (<<
						maybe_non_breaking_white_space,
						character_literal (';'),
						maybe_non_breaking_white_space,
						assignment
					>>)
				)
			>>)
		end

feature {NONE} -- Title parsing actions

	on_name (matched_text: EL_STRING_VIEW)
			--
		local
			last_node: EL_DOCUMENT_NODE
		do
			attribute_list.extend
			last_node := attribute_list.last_node
			last_node.set_name_from_view (matched_text)
			String_32.replace_character (last_node.name, '.', ':')
		end

	on_quoted_value (matched_text: EL_STRING_VIEW; is_double_quote: BOOLEAN)
			--
		local
			last_node: EL_DOCUMENT_NODE
		do
			last_node := attribute_list.last_node
			last_node.set_raw_content_from_view (matched_text)
			Quote_unescaper.item (is_double_quote).unescape (last_node.raw_content)
		end

	on_value (matched_text: EL_STRING_VIEW)
			--
		do
			attribute_list.last_node.set_raw_content_from_view (matched_text)
		end

feature {NONE} -- Initialization

	attribute_list: EL_ELEMENT_ATTRIBUTE_LIST

end