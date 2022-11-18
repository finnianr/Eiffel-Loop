note
	description: "Procedure praat run gcc to msvc converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	PROCEDURE_PRAAT_RUN_GCC_TO_MSVC_CONVERTER

inherit
	EL_FILE_PARSER_TEXT_FILE_CONVERTER
		rename
			output as file_output,
			new_output as actual_file_output
		export
			{FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER} set_source_text
		redefine
			file_output, actual_file_output, close
		end

	EL_C_LANGUAGE_PATTERN_FACTORY

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (a_file_output: EL_PLAIN_TEXT_FILE)
			--
		do
			make_default
			actual_file_output := a_file_output
		end

feature {NONE} -- C constructs

	delimiting_pattern: like all_of
			-- Abbreviated Eg.

			-- if (Melder_batch) {
			--  ..
			-- } else /* GUI */ {
			-- 	..
			-- }
		do
			Result := all_of (<<
				start_of_line,
				nonbreaking_white_space,
				string_literal ("if (Melder_batch)"),
				nonbreaking_white_space,

				statement_block,

				-- 	else /* GUI */
				nonbreaking_white_space,
				string_literal ("else"),
				nonbreaking_white_space,
				comment,
				nonbreaking_white_space,

				statement_block

			>>) |to| agent on_if_melder_batch_statement_block
		end

feature {NONE} -- Match actions

	on_if_melder_batch_statement_block (start_index, end_index: INTEGER)
			--
		do
			put_new_line
			put_string ("%T#if ! defined (EIFFEL_APPLICATION)")
			put_new_line
			put_string (source_substring (start_index, end_index, False))
			put_new_line
			put_string ("%T#endif%T//defined ! (EIFFEL_APPLICATION)")

		end

feature {NONE} -- Implementation

	actual_file_output: EL_PLAIN_TEXT_FILE

	file_output: EL_PLAIN_TEXT_FILE

	close
			--
		do
		end

end
