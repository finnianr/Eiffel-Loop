note
	description: "[
		parse something like: 
		
			{MY_CLASS}.my_routine (1, {E2X_VECTOR_COMPLEX_DOUBLE}, 0.1, 2.3e-15, 'hello')
		OR
			{MY_CLASS}.my_routine
			
		Note: `E2X_VECTOR_COMPLEX_DOUBLE' is an example of a place holder for an instance of a class
		deserialized from XML
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_ROUTINE_CALL_REQUEST_PARSER

inherit
	EL_PARSER
		rename
			make_default as make,
			source_text as call_request_source_text
		redefine
			make, reset
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY
		rename
			class_name as class_name_pattern,
			single_quote as single_quote_pattern
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create routine_name.make_empty
			create argument_list.make (3)
			Precursor
		end

feature -- Access

	routine_name: STRING

	class_name: STRING

	argument_list: ARRAYED_LIST [STRING]

feature {NONE} -- Syntax grammar

	new_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				class_object_place_holder |to| agent on_class_name,
				character_literal ('.'),
				c_identifier |to| agent on_routine_name,
				maybe_white_space,
				optional (argument_list_pattern)
			>>)
		end

	argument_list_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				character_literal ('('),
				maybe_white_space,
				argument,
				while_not_p1_repeat_p2 (
					right_bracket,

					-- pattern 2
					all_of (<<
						maybe_white_space,
						character_literal (','),
						maybe_white_space,
						argument
					>>)
				)
			>>)
		end

	argument: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of ( <<
				class_object_place_holder 	|to| agent on_argument,
				singley_quoted_string 		|to| agent on_argument,
				double_constant 				|to| agent on_numeric_argument,
				integer_constant 				|to| agent on_numeric_argument,
				boolean_constant				|to| agent on_boolean_argument,
				identifier						|to| agent on_identifier_argument
			>> )
		end

	class_object_place_holder: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				character_literal ('{'), class_name_pattern, character_literal ('}')
			>> )
		end

	boolean_constant: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				string_literal ("true"),
				string_literal ("false")
			>>)
		end

	singley_quoted_string: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				single_quote, while_not_p1_repeat_p2 (single_quote, any_character)
			>> )
		end

	single_quote: EL_LITERAL_CHAR_TP
			--
		do
			create Result.make ({ASCII}.Singlequote.to_natural_32)
		end

	right_bracket: EL_LITERAL_CHAR_TP
			--
		do
			create Result.make_from_character (')')
		end

feature {NONE} -- Parsing match events

	on_class_name (matched_text: EL_STRING_VIEW)
			--
		do
			class_name := matched_text
			class_name.remove_head (1)
			class_name.remove_tail (1)
		end

	on_routine_name (matched_text: EL_STRING_VIEW)
			--
		do
			routine_name := matched_text
		end

	on_argument (matched_text: EL_STRING_VIEW)
			--
		do
			argument_list.extend (matched_text)
		end

	on_numeric_argument (matched_text: EL_STRING_VIEW)
			--
		do
			argument_list.extend (once "(" + matched_text.to_string_8 + once ")")
		end

	on_boolean_argument (matched_text: EL_STRING_VIEW)
			--
		do
			argument_list.extend (once "<" + matched_text.to_string_8 + once ">")
		end

	on_identifier_argument (matched_text: EL_STRING_VIEW)
			--
		do
			argument_list.extend (once "[" + matched_text.to_string_8 + once "]")
		end

feature {NONE} -- Implementation

	reset
			--
		do
			Precursor
			routine_name.clear_all
			argument_list.wipe_out
		end

end