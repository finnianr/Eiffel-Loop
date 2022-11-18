note
	description: "File praat c gcc to msvc converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER

inherit
	GCC_TO_MSVC_CONVERTER
		redefine
			delimiting_pattern, edit
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- C constructs

	delimiting_pattern: like one_of
			--
		do
			Result := Precursor
			Result.extend (praat_run_procedure)
			Result.extend (exit_program_call)
			Result.extend (static_praat_exit_procedure_declaration)
		end

	praat_run_procedure: like all_of
			--
		do
			Result := all_of (<<
				string_literal ("void praat_run (void)") |to| agent on_unmatched_text,
				nonbreaking_white_space,
				statement_block |to| agent on_praat_run_procedure_statement_block
			>>)
		end

	exit_program_call: like all_of
			--
		do
			Result := all_of (<<
				start_of_line,
				nonbreaking_white_space,
				string_literal ("exit (exit_code);")

			>>) |to| agent on_exit_program_call
		end

	static_praat_exit_procedure_declaration: like all_of
			--
		do
			Result := all_of (<<
				start_of_line,
				string_literal ("static void praat_exit")

			>>) |to| agent on_static_praat_exit_procedure_declaration
		end


feature {NONE} -- Match actions

	on_praat_run_procedure_statement_block (start_index, end_index: INTEGER)
			--
		do
			log.enter ("on_praat_run_procedure_statement_block")
			if attached source_substring (start_index, end_index, False) as text then
				log.put_string_field_to_max_length ("text", text, 100)
				log.put_new_line
			end
			praat_run_c_procedure_converter.set_source_text (
				source_substring (start_index, end_index, False)
			)
			praat_run_c_procedure_converter.edit
			log.exit
		end

	on_exit_program_call (start_index, end_index: INTEGER)
			--
		do
			put_new_line
			put_string ("%T#if ! defined (EIFFEL_APPLICATION)")
			put_new_line
			put_string (source_substring (start_index, end_index, False))
			put_new_line
			put_string ("%T#endif")
		end

	on_static_praat_exit_procedure_declaration (start_index, end_index: INTEGER)
			--
		do
			put_string (praat_exit_macro)
			put_new_line
			put_string ("PRAAT_EXIT")
		end

feature {NONE} -- Implementation

	edit
			--
		do
			create praat_run_c_procedure_converter.make (output)
			Precursor
		end

	praat_run_c_procedure_converter: PROCEDURE_PRAAT_RUN_GCC_TO_MSVC_CONVERTER

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
