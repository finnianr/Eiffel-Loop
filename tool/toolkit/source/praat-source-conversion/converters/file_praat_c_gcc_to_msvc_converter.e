note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER

inherit
	GCC_TO_MSVC_CONVERTER
		rename
			output as file_output
		redefine
			delimiting_pattern, write_new_text, file_output
		end

	EL_C_PATTERN_FACTORY

create
	make

feature {NONE} -- C constructs

	delimiting_pattern: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := Precursor
			Result.extend (praat_run_procedure)
			Result.extend (exit_program_call)
			Result.extend (static_praat_exit_procedure_declaration)
		end

	praat_run_procedure: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				string_literal ("void praat_run (void)") |to| agent on_unmatched_text,
				non_breaking_white_space,
				statement_block |to| agent on_praat_run_procedure_statement_block
			>>)
		end

	exit_program_call: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				start_of_line,
				non_breaking_white_space,
				string_literal ("exit (exit_code);")

			>>) |to| agent on_exit_program_call
		end

	static_praat_exit_procedure_declaration: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				start_of_line,
				string_literal ("static void praat_exit")

			>>) |to| agent on_static_praat_exit_procedure_declaration
		end


feature {NONE} -- Match actions

	on_praat_run_procedure_statement_block (text: EL_STRING_VIEW)
			--
		do
			log.enter ("on_praat_run_procedure_statement_block")
			log.put_string_field_to_max_length ("text", text, 100)
			log.put_new_line
			praat_run_c_procedure_converter.set_source_text (text.view)
			praat_run_c_procedure_converter.edit_file
			log.exit
		end

	on_exit_program_call (text: EL_STRING_VIEW)
			--
		do
			put_new_line
			put_string ("%T#if ! defined (EIFFEL_APPLICATION)")
			put_new_line
			put_string (text)
			put_new_line
			put_string ("%T#endif")
		end

	on_static_praat_exit_procedure_declaration (text: EL_STRING_VIEW)
			--
		do
			put_string (praat_exit_macro)
			put_new_line
			put_string ("PRAAT_EXIT")
		end

feature {NONE} -- Implementation

	write_new_text
			--
		do
			create praat_run_c_procedure_converter.make (file_output)
			Precursor
		end

	praat_run_c_procedure_converter: PROCEDURE_PRAAT_RUN_GCC_TO_MSVC_CONVERTER

	file_output: PLAIN_TEXT_FILE

	praat_exit_macro: STRING =
			--
		"[
			#if defined (EIFFEL_APPLICATION)
				#define PRAAT_EXIT void praat_exit
			#else
				#define PRAAT_EXIT static void praat_exit
			#endif
		]"


end
