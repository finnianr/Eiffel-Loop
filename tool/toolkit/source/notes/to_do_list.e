note
	description: "Summary description for {TO_DO_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

end
