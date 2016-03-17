note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-21 11:21:19 GMT (Thursday 21st January 2016)"
	revision: "6"

class
	PROCEDURE_PRAAT_RUN_GCC_TO_MSVC_CONVERTER

inherit
	EL_FILE_EDITING_PROCESSOR
		rename
			output as file_output,
			new_output as actual_file_output
		export
			{FILE_PRAAT_C_GCC_TO_MSVC_CONVERTER} set_source_text
		redefine
			file_output, actual_file_output, close
		end

	EL_C_PATTERN_FACTORY

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
				non_breaking_white_space,
				string_literal ("if (Melder_batch)"),
				non_breaking_white_space,

				statement_block,

				-- 	else /* GUI */
				non_breaking_white_space,
				string_literal ("else"),
				non_breaking_white_space,
				comment,
				non_breaking_white_space,

				statement_block

			>>) |to| agent on_if_melder_batch_statement_block
		end

feature {NONE} -- Match actions

	on_if_melder_batch_statement_block (text: EL_STRING_VIEW)
			--
		do
			put_new_line
			put_string ("%T#if ! defined (EIFFEL_APPLICATION)")
			put_new_line
			put_string (text)
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
