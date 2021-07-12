note
	description: "Pyxis attribute parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 8:25:01 GMT (Monday 12th July 2021)"
	revision: "14"

class
	EL_PYXIS_ATTRIBUTE_PARSER

inherit
	EL_PARSER

	EL_PYXIS_TEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

	EL_PYXIS_UNESCAPE_CONSTANTS

	EL_DOCUMENT_CLIENT

create
	make

feature {NONE} -- Initialization

	make (a_attribute_list: like attribute_list; a_last_node: EL_DOCUMENT_NODE_STRING)
		do
			attribute_list := a_attribute_list; last_node := a_last_node
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
			name: EL_UTF_8_STRING; s: EL_STRING_8_ROUTINES
		do
			attribute_list.extend (last_node.document_dir)
			name := attribute_list.last.raw_name
			name.wipe_out
			matched_text.append_to (name)
			s.replace_character (name, '.', ':')
		end

	on_quoted_value (matched_text: EL_STRING_VIEW; is_double_quote: BOOLEAN)
			--
		local
			last_attribute: EL_ELEMENT_ATTRIBUTE_NODE_STRING
		do
			last_attribute := attribute_list.last
			last_attribute.set_from_view (matched_text)
			last_attribute.unescape (Quote_unescaper [is_double_quote])
		end

	on_value (matched_text: EL_STRING_VIEW)
			--
		do
			attribute_list.last.set_from_view (matched_text)
		end

feature {NONE} -- Initialization

	attribute_list: EL_ELEMENT_ATTRIBUTE_LIST

	last_node: EL_DOCUMENT_NODE_STRING

end