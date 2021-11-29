note
	description: "Evolicity evaluate directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-29 11:00:10 GMT (Monday 29th November 2021)"
	revision: "16"

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
			new_line_split: EL_SPLIT_ZSTRING_ON_CHARACTER; template_path: EL_FILE_PATH
		do
			if attached {EVOLICITY_CONTEXT} context.referenced_item (variable_ref) as new_context then
				if not template_name.is_empty then
					template_path := template_name

				elseif not template_name_variable_ref.is_empty
					and then attached {EL_FILE_PATH} context.referenced_item (template_name_variable_ref) as context_template_name
				then
					template_path := context_template_name
				end
				new_context.prepare
				if not Evolicity_templates.has (template_path) and then template_path.exists then
					-- Assume template encoding is same as output encoding
					Evolicity_templates.put_file (template_path, output)
				end
				if Evolicity_templates.is_nested_output_indented then
					across Reuseable_medium as reuse loop
						if attached reuse.item as medium then
							medium.open_write
							Evolicity_templates.merge (template_path, new_context, medium)
							new_line_split := medium.text.split ('%N')
							medium.close
							across new_line_split as line loop
								if not tabs.is_empty then
									output.put_raw_string_8 (tabs)
								end
								output.put_string (line.item)
								output.put_new_line
							end
						end
					end
				else
					Evolicity_templates.merge (template_path, new_context, output)
				end
			end
		end

feature {NONE} -- Internal attributes

	template_name: ZSTRING

	template_name_variable_ref: EVOLICITY_VARIABLE_REFERENCE

feature {NONE} -- Constants

	Reuseable_medium: EL_BORROWED_OBJECT_SCOPE [EL_ZSTRING_IO_MEDIUM]
		-- scope from which an instance of `EL_ZSTRING_IO_MEDIUM' can be borrowed
		once
			create Result.make_with_agent (agent: EL_ZSTRING_IO_MEDIUM do create Result.make (500) end)
		end

end