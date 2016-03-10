note
	description: "Summary description for {TO_DO_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 14:15:42 GMT (Saturday 26th December 2015)"
	revision: "4"

class
	TO_DO_LIST

inherit
	PROJECT_NOTES

feature -- Access

	help_info
		do
--			Add help info compilation to EL_COMMAND_LINE_SUB_APPLICATION. Add an attribute
--			help_requested: BOOLEAN
		end

	string_list_view
		do
--			Introduce the idea of a EL_STRING_LIST_VIEW to avoid concatenating file strings	
		end

	evolicity_templates
		do
--			Template indent is fine so long as blank lines have leading tabs consistent with other lines
--			Could the problem be in el_toolkit text editing which is changing the template
		end

	c_statement_block
		do
			-- EL_C_PATTERN_FACTORY
			-- in recurse in `statement_block', how do we decide if it has actions or not?
		end

	text_editor_class
		do
			-- Make sure descendants of EL_TEXT_EDITOR.new_output are set to correct encoding

		end

	back_reference
		do
			-- Finish EL_BACK_REFERENCE_MATCH_TP
		end

	occurrence_substrings
		do
			-- Fix EL_OCCURRENCE_SUBSTRINGS to use INTEGER_64 interval representation
		end

	code_generator
		do
			-- Check is_upper and is_lower is being generated correctly for ISO-8859-15
		end

end
