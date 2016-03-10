note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "6"

class
	PRAAT_MAKE_FILE_PARSER

inherit
	EL_FILE_PARSER
		export
			{NONE} all
		end

	EL_TEXTUAL_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create c_library_name_list.make
		end

feature -- Basic operations

	new_c_library (make_file_path: EL_FILE_PATH)
			--
		do
			create c_library.make
			set_source_text_from_file (make_file_path)
			find_all
			consume_events
		end

feature {NONE} -- Patterns

	new_pattern: EL_TEXTUAL_PATTERN
			--
		do
			Result := one_of (<<
				c_flag_include_list_assignment,
				c_object_list_assignment,
				make_target_rule
			>>)
		end

	c_object_list_assignment: EL_TEXTUAL_PATTERN
			-- List of target objects assigned to 'OBJECTS' variable as in example:

			--    OBJECTS = NUM.o NUMarrays.o NUMrandom.o NUMsort.o NUMear.o \
			--         enum.o abcio.o lispio.o longchar.o complex.o
			--
		do
			Result := all_of (<<
				string_literal ("OBJECTS"),
				maybe_non_breaking_white_space,
				character_literal ('='),
				maybe_non_breaking_white_space,
				c_object_list
			>>)
		end

	c_object_list: EL_TEXTUAL_PATTERN
			--
		do
			Result := all_of (<<
				while_not_pattern_1_repeat_pattern_2 (
--					pattern 1
					all_of ( <<
						c_object_name,
						end_of_line_character
					>>),

--					pattern 2
					all_of ( <<
						c_object_name,
						one_of (<< line_continuation_backslash, non_breaking_white_space  >>)
					>>)

				)
			>>)
		end

	c_object_name: EL_TEXTUAL_PATTERN
			--
		do
			Result := all_of (<<
				c_identifier |to| agent on_c_object_name,
				string_literal (".o")
			>>)
		end

	c_flag_include_list_assignment: EL_TEXTUAL_PATTERN
			-- List of include passed to compiler
			-- Assumes all on one line and not split across several lines

			--    CFLAGS = -I ../sys -I ../fon -I ../dwtools -I ../GSL -I ../dwsys

		do
			Result := all_of (<<
				string_literal ("CFLAGS"),
				maybe_non_breaking_white_space,
				character_literal ('='),
				maybe_non_breaking_white_space,
				include_option_list
			>>)
		end

	include_option_list: EL_TEXTUAL_PATTERN
			--
		do
			Result := all_of (<<
				while_not_pattern_1_repeat_pattern_2 (
--					pattern 1
					all_of (<< include_option, end_of_line_character >>),

--					pattern 2
					all_of (<< include_option, non_breaking_white_space >>)

				)
			>>)
		end

	include_option: EL_TEXTUAL_PATTERN
			--
		do
			Result := all_of (<<
				string_literal ("-I"),
				maybe_non_breaking_white_space,
				include_path
			>>)
		end

	include_path: EL_TEXTUAL_PATTERN
			--
		do
			Result := one_or_more (
				one_of (<<
					string_literal ("../"),
					c_identifier
				>>)
			)
			Result.set_action_on_match (agent on_include_path)
		end

	line_continuation_backslash: EL_TEXTUAL_PATTERN
			--
		do
			Result := all_of (<<
				maybe_non_breaking_white_space,
				character_literal ('\'),
				white_space
			>>)
		end

	make_target_rule: EL_TEXTUAL_PATTERN
			--
		do
			Result := all_of (<<
				string_literal ("all:"),
				maybe_non_breaking_white_space,
				string_literal ("lib"),
				c_identifier |to| agent on_make_target_rule_library_name,
				string_literal (".a"),
				white_space
			>>)
		end

feature -- Pattern match handlers

	on_make_target_rule_library_name (library_name: EL_STRING_VIEW)
			--
		do
			c_library.set_library_name (library_name)
			c_library_name_list.extend (library_name)
		end

	on_c_object_name (name: EL_STRING_VIEW)
			--
		local
			object_name: STRING
		do
			object_name := name
			c_library.add_c_library_object_name (object_name)
		end

	on_include_path (path: EL_STRING_VIEW)
			--
		do
			c_library.add_include_directory (path)
		end

feature -- Access

	c_library: PRAAT_LIB_MAKE_FILE_GENERATOR

	c_library_name_list: LINKED_LIST [STRING]

end
