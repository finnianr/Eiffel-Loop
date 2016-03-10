note
	description: "Summary description for {EVOLICITY_INCLUDE_DIRECTIVE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-24 16:02:17 GMT (Sunday 24th November 2013)"
	revision: "4"

class
	EVOLICITY_INCLUDE_DIRECTIVE

inherit
	EVOLICITY_NESTED_TEMPLATE_DIRECTIVE

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal, copy
		end

create
	make

feature -- Basic operations

	execute (context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		local
			line_source: EL_FILE_LINE_SOURCE
		do
			if attached {ASTRING} context.referenced_item (variable_ref) as file_path then
				create line_source.make (file_path)
				if output.is_utf8_encoded then
					line_source.set_utf_encoding (8)
				end
				if Evolicity_templates.is_nested_output_indented then
					output.put_indented_lines (tabs, line_source)
				else
					from line_source.start until line_source.after loop
						output.put_string (line_source.item)
						output.put_new_line
						line_source.forth
					end
				end
			end
		end

end
