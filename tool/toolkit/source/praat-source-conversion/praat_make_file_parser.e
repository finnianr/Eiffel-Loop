note
	description: "Praat make file parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:40:29 GMT (Monday 21st November 2022)"
	revision: "8"

class
	PRAAT_MAKE_FILE_PARSER

inherit
	EL_FILE_PARSER
		export
			{NONE} all
		end

	TP_C_LANGUAGE_FACTORY
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

	new_c_library (make_file_path: FILE_PATH)
			--
		do
			create c_library.make
			set_source_text_from_file (make_file_path)
			find_all (Void)
		end

feature {NONE} -- Patterns

	c_flag_include_list_assignment: like all_of
			-- List of include passed to compiler
			-- Assumes all on one line and not split across several lines

			--    CFLAGS = -I ../sys -I ../fon -I ../dwtools -I ../GSL -I ../dwsys

		do
			Result := all_of (<<
				string_literal ("CFLAGS"),
				optional_nonbreaking_white_space,
				character_literal ('='),
				optional_nonbreaking_white_space,
				include_option_list
			>>)
		end

	c_object_list: like all_of
			--
		do
			Result := all_of (<<
				while_not_p1_repeat_p2 (
--					pattern 1
					all_of ( <<
						c_object_name,
						end_of_line_character
					>>),

--					pattern 2
					all_of ( <<
						c_object_name,
						one_of (<< line_continuation_backslash, nonbreaking_white_space  >>)
					>>)

				)
			>>)
		end

	c_object_list_assignment: like all_of
			-- List of target objects assigned to 'OBJECTS' variable as in example:

			--    OBJECTS = NUM.o NUMarrays.o NUMrandom.o NUMsort.o NUMear.o \
			--         enum.o abcio.o lispio.o longchar.o complex.o
			--
		do
			Result := all_of (<<
				string_literal ("OBJECTS"),
				optional_nonbreaking_white_space,
				character_literal ('='),
				optional_nonbreaking_white_space,
				c_object_list
			>>)
		end

	c_object_name: like all_of
			--
		do
			Result := all_of (<<
				identifier |to| agent on_c_object_name,
				string_literal (".o")
			>>)
		end

	include_option: like all_of
			--
		do
			Result := all_of (<<
				string_literal ("-I"),
				optional_nonbreaking_white_space,
				include_path
			>>)
		end

	include_option_list: like all_of
			--
		do
			Result := all_of (<<
				while_not_p1_repeat_p2 (
--					pattern 1
					all_of (<< include_option, end_of_line_character >>),

--					pattern 2
					all_of (<< include_option, nonbreaking_white_space >>)

				)
			>>)
		end

	include_path: like one_or_more
			--
		do
			Result := one_or_more (one_of (<< string_literal ("../"), identifier >>)) |to| agent on_include_path
		end

	line_continuation_backslash: like all_of
			--
		do
			Result := all_of (<<
				optional_nonbreaking_white_space,
				character_literal ('\'),
				white_space
			>>)
		end

	make_target_rule: like all_of
			--
		do
			Result := all_of (<<
				string_literal ("all:"),
				optional_nonbreaking_white_space,
				string_literal ("lib"),
				identifier |to| agent on_make_target_rule_library_name,
				string_literal (".a"),
				white_space
			>>)
		end

	new_pattern: like one_of
			--
		do
			Result := one_of (<<
				c_flag_include_list_assignment,
				c_object_list_assignment,
				make_target_rule
			>>)
		end

feature -- Pattern match handlers

	on_c_object_name (start_index, end_index: INTEGER)
			--
		local
			object_name: ZSTRING
		do
			object_name := source_substring (start_index, end_index, True)
			c_library.add_c_library_object_name (object_name)
		end

	on_include_path (start_index, end_index: INTEGER)
			--
		do
			c_library.add_include_directory (source_substring (start_index, end_index, True))
		end

	on_make_target_rule_library_name (start_index, end_index: INTEGER)
			--
		do
			if attached source_substring (start_index, end_index, True) as library_name then
				c_library.set_library_name (library_name)
				c_library_name_list.extend (library_name)
			end
		end

feature -- Access

	c_library: PRAAT_LIB_MAKE_FILE_GENERATOR

	c_library_name_list: LINKED_LIST [ZSTRING]

end