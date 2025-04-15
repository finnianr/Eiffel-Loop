note
	description: "[
		Parse call expression like for example:
		
			{MY_CLASS}.my_routine (1, {COLUMN_VECTOR_COMPLEX_64}, 0.1, 2.3e-15, 'hello')
		OR
			{MY_CLASS}.my_routine
			
		Note: `COLUMN_VECTOR_COMPLEX_64' is an example of a place holder for an instance of a class
		deserialized from XML
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 15:23:19 GMT (Tuesday 15th April 2025)"
	revision: "17"

class
	EROS_CALL_REQUEST_PARSER

inherit
	EL_PARSER_8
		rename
			make_default as make,
			source_text as call_text,
			default_source_text as default_call_text
		redefine
			make, reset
		end

	TP_EIFFEL_FACTORY
		rename
			class_name as class_name_pattern
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create routine_name.make_empty
			create class_name.make_empty
			create argument_list.make (3)
			Precursor
		end

feature -- Access

	argument_list: EL_STRING_8_LIST

	call_argument: detachable EL_BUILDABLE_FROM_NODE_SCAN
		do
		end

	class_name: STRING

	routine_name: STRING

feature -- Status report

	has_call_argument: BOOLEAN
		do
		end

	has_error: BOOLEAN

feature -- Basic operations

	try_parse (a_call_text: STRING)
			--
		do
			if a_call_text.is_empty then
				has_error := True
			else
				set_source_text (a_call_text)
				parse
				has_error := not fully_matched
			end
		end

feature {NONE} -- Syntax grammar

	argument: like one_of
			--
		do
			Result := one_of ( <<
				class_object_place_holder 			|to| agent on_argument,
				basic_quoted_string ('%'', Void)	|to| agent on_argument,
				decimal_constant						|to| agent on_argument,
				signed_integer							|to| agent on_argument,
				boolean_constant						|to| agent on_argument,
				identifier								|to| agent on_argument
			>>)
		end

	argument_list_pattern: like all_of
			--
		do
			Result := all_of (<<
				character_literal ('('),
				optional_white_space,
				argument,
				while_not_p1_repeat_p2 (
					character_literal (')'),

					-- pattern 2
					all_of_separated_by (optional_white_space, <<
						character_literal (','),
						argument
					>>)
				)
			>>)
		end

	boolean_constant: like one_of
			--
		do
			Result := one_of (<<
				string_literal_caseless ("true"),
				string_literal_caseless ("false")
			>>)
		end

	class_object_place_holder: like all_of
			--
		do
			Result := all_of ( <<
				character_literal ('{'), class_name_pattern, character_literal ('}')
			>> )
		end

	new_pattern: like all_of
			--
		do
			Result := all_of (<<
				class_object_place_holder |to| agent on_class_name,
				character_literal ('.'),
				identifier |to| agent on_routine_name,
				optional_white_space,
				optional (argument_list_pattern)
			>>)
		end

feature {NONE} -- Parsing match events

	on_argument (start_index, end_index: INTEGER)
			--
		do
			argument_list.extend (new_source_substring (start_index, end_index))
		end

	on_class_name (start_index, end_index: INTEGER)
			--
		do
			class_name := new_source_substring (start_index + 1, end_index - 1)
		end

	on_routine_name (start_index, end_index: INTEGER)
			--
		do
			routine_name := new_source_substring (start_index, end_index)
		end

feature {NONE} -- Implementation

	reset
			--
		do
			Precursor
			routine_name.wipe_out
			argument_list.wipe_out
		end

end