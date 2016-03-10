note
	description: "Summary description for {EVOLICITY_EVALUATE_DIRECTIVE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:03 GMT (Monday 22nd July 2013)"
	revision: "3"

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

	set_template_name (a_name: EL_ASTRING)
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

	execute (context: EVOLICITY_CONTEXT; output: IO_MEDIUM; utf8_encoded: BOOLEAN)
			--
		local
			l_template_name: EL_FILE_PATH
		do
			if attached {EVOLICITY_CONTEXT} context.referenced_item (variable_ref) as new_context then
				if not template_name.is_empty then
					l_template_name := template_name

				elseif not template_name_variable_ref.is_empty and then
						 attached {EL_FILE_PATH} context.referenced_item (template_name_variable_ref) as context_template_name
				then
					l_template_name := context_template_name
				end

				if Evolicity_engine.is_nested_output_indented then
					put_indented_string (output, Evolicity_engine.merged_template (l_template_name, new_context), utf8_encoded)
				else
					Evolicity_engine.merge_to_stream (l_template_name, new_context, output)
				end
			end
		end

feature {NONE} -- Implementation

	template_name: EL_ASTRING

	template_name_variable_ref: EVOLICITY_VARIABLE_REFERENCE

end
