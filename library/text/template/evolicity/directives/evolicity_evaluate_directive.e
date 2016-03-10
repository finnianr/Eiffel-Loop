note
	description: "Summary description for {EVOLICITY_EVALUATE_DIRECTIVE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-24 16:02:17 GMT (Sunday 24th November 2013)"
	revision: "4"

class
	EVOLICITY_EVALUATE_DIRECTIVE

inherit
	EVOLICITY_NESTED_TEMPLATE_DIRECTIVE
		redefine
			make
		end

create
	make

feature -- Initialization

	make
			--
		do
			Precursor
			create template_name.make_empty
			create template_name_variable_ref
		end

feature -- Element change

	set_template_name (a_name: ASTRING)
			--
		do
			template_name := a_name
		end

	set_template_name_variable_ref (a_template_name_variable_ref: like template_name_variable_ref)
			--
		do
			template_name_variable_ref := a_template_name_variable_ref
		end

feature -- Basic operations

	execute (context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		local
			l_template_name: EL_FILE_PATH
			merged_text: READABLE_STRING_GENERAL
		do
			if attached {EVOLICITY_CONTEXT} context.referenced_item (variable_ref) as new_context then
				if not template_name.is_empty then
					l_template_name := template_name

				elseif not template_name_variable_ref.is_empty and then
						 attached {EL_FILE_PATH} context.referenced_item (template_name_variable_ref) as context_template_name
				then
					l_template_name := context_template_name
				end
				new_context.prepare
				if Evolicity_templates.is_nested_output_indented then
					if output.is_utf8_encoded then
						merged_text := Evolicity_templates.merged_utf_8 (l_template_name, new_context)
					else
						merged_text := Evolicity_templates.merged (l_template_name, new_context)
					end
					output.put_indented_lines (tabs, merged_text.split ('%N'))
				else
					Evolicity_templates.merge (l_template_name, new_context, output)
				end
			end
		end

feature {NONE} -- Implementation

	template_name: ASTRING

	template_name_variable_ref: EVOLICITY_VARIABLE_REFERENCE

end
