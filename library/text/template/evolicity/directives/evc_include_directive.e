note
	description: "Evolicity include directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:01:31 GMT (Tuesday 18th March 2025)"
	revision: "14"

class
	EVC_INCLUDE_DIRECTIVE

inherit
	EVC_NESTED_TEMPLATE_DIRECTIVE

	EL_MODULE_FILE_SYSTEM

create
	make

feature -- Basic operations

	execute (context: EVC_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		local
			line_source: EL_PLAIN_TEXT_LINE_SOURCE; template_path: detachable FILE_PATH
		do
			if attached template_file_path (context) as path then
				template_path := path

			elseif attached {ZSTRING} context.referenced_item (variable_ref) as path then
				template_path := path
			end
			if attached template_path as path and then path.exists then
				create line_source.make (output.encoding, path)

				if Evolicity_templates.is_nested_output_indented then
					output.put_indented_lines (tabs, line_source)
				else
					from line_source.start until line_source.after loop
						output.put_string (line_source.shared_item)
						output.put_new_line
						line_source.forth
					end
				end
			end
		end

end