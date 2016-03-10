note
	description: "Summary description for {EVOLICITY_EVALUATE_DIRECTIVE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-22 11:23:10 GMT (Tuesday 22nd December 2015)"
	revision: "6"

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
			create template_name_variable_ref.make_empty
		end

feature -- Element change

	set_template_name (a_name: ZSTRING)
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
		do
			if attached {EVOLICITY_CONTEXT} context.referenced_item (variable_ref) as new_context then
				if not template_name.is_empty then
					l_template_name := template_name

				elseif not template_name_variable_ref.is_empty
					and then attached {EL_FILE_PATH} context.referenced_item (template_name_variable_ref) as context_template_name
				then
					l_template_name := context_template_name
				end
				new_context.prepare
				if Evolicity_templates.is_nested_output_indented then
					output.put_indented_lines (tabs, Evolicity_templates.merged (l_template_name, new_context).lines)
				else
					Evolicity_templates.merge (l_template_name, new_context, output)
				end
			end
		end

feature {NONE} -- Implementation

	template_name: ZSTRING

	template_name_variable_ref: EVOLICITY_VARIABLE_REFERENCE

end
