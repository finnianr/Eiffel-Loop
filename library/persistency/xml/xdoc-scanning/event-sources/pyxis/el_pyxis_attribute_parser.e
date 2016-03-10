note
	description: "Summary description for {EL_PYXIS_ATTRIBUTE_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:01 GMT (Monday 22nd July 2013)"
	revision: "4"

class
	EL_PYXIS_ATTRIBUTE_PARSER

inherit
	EL_FILE_PARSER
		rename
			make as make_parser,
			match_full as parse
		redefine
			parse
		end

	EL_PYXIS_PATTERN_FACTORY
		export
			{NONE} all
		end

	EL_MODULE_STRING

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_parser
			create attribute_list.make (5)
		end

feature -- Access

	attribute_list: ARRAYED_LIST [like last_attribute]

feature -- Basic operations

	parse
			--
		do
			attribute_list.wipe_out
			Precursor
			if full_match_succeeded then
				consume_events
			end
		end

feature {NONE} -- Pattern definitions		

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
					quoted_string_with_escape_sequence (double_quote_escape_sequence, agent on_quoted_value (True, ?)),
					single_quoted_string_with_escape_sequence (single_quote_escape_sequence, agent on_quoted_value (False, ?))
				>>)
			>> )
		end

feature {NONE} -- Title parsing actions

	on_name (matched_text: EL_STRING_VIEW)
			--
		do
			create last_attribute
			last_attribute.name := matched_text
			String.subst_all_characters (last_attribute.name, '.', ':')
			attribute_list.extend (last_attribute)
		end

	on_value (matched_text: EL_STRING_VIEW)
			--
		do
			last_attribute.value := matched_text
		end

	on_quoted_value (is_double_quote: BOOLEAN; matched_text: EL_STRING_VIEW)
			--
		do
			if is_double_quote then
				last_attribute.value := String.unescaped_Python_double_quoted (matched_text)
			else
				last_attribute.value := String.unescaped_Python_single_quoted (matched_text)
			end
		end

feature {NONE} -- Implementation

	last_attribute: TUPLE [name, value: EL_ASTRING]

end
