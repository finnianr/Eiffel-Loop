note
	description: "Summary description for {EVOLICITY_INCLUDE_DIRECTIVE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-01 12:12:52 GMT (Friday 1st September 2017)"
	revision: "2"

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
			if attached {ZSTRING} context.referenced_item (variable_ref) as file_path then
				create line_source.make_encoded (output, file_path)
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
