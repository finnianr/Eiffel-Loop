note
	description: "Evolicity include directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 9:29:34 GMT (Thursday 7th May 2020)"
	revision: "7"

class
	EVOLICITY_INCLUDE_DIRECTIVE

inherit
	EVOLICITY_NESTED_TEMPLATE_DIRECTIVE

	EL_MODULE_FILE_SYSTEM

create
	make

feature -- Basic operations

	execute (context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		local
			line_source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			if attached {ZSTRING} context.referenced_item (variable_ref) as file_path then
				create line_source.make (output.encoding, file_path)
				line_source.enable_shared_item

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
