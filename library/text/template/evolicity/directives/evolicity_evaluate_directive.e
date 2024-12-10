note
	description: "Evolicity evaluate directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-12-10 10:02:55 GMT (Tuesday 10th December 2024)"
	revision: "23"

class
	EVOLICITY_EVALUATE_DIRECTIVE

inherit
	EVOLICITY_NESTED_TEMPLATE_DIRECTIVE
		redefine
			make
		end

	EL_SHARED_ZSTRING_BUFFER_POOL

create
	make

feature -- Initialization

	make
			--
		do
			Precursor
			create template_name_variable_ref.make_empty
		end

feature -- Element change

	set_template_name_variable_ref (a_template_name_variable_ref: EVOLICITY_VARIABLE_REFERENCE)
			--
		do
			template_name_variable_ref := a_template_name_variable_ref
		end

feature -- Basic operations

	execute (context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		local
			new_line_split: EL_SPLIT_ZSTRING_ON_CHARACTER; template_path: FILE_PATH
			medium: EL_ZSTRING_IO_MEDIUM
		do
			if attached {EVOLICITY_CONTEXT} context.referenced_item (variable_ref) as new_context then
				if attached template_file_path (context) as path then
					template_path := path

				elseif not template_name_variable_ref.is_empty
					and then attached {FILE_PATH} context.referenced_item (template_name_variable_ref) as context_template_name
				then
					template_path := context_template_name
				end
				new_context.prepare
				if not Evolicity_templates.has (template_path) and then template_path.exists then
					-- Assume template encoding is same as output encoding
					Evolicity_templates.put_file (template_path, output)
				end
				if Evolicity_templates.is_nested_output_indented then
					if attached String_pool.borrowed_item as borrowed then
						create medium.make_open_write_to_text (borrowed.empty)
						Evolicity_templates.merge (template_path, new_context, medium)
						across medium.text.split ('%N') as line loop
							if not tabs.is_empty then
								output.put_encoded_string_8 (tabs)
							end
							output.put_string (line.item)
							output.put_new_line
						end
						medium.close
						borrowed.return
					end
				else
					Evolicity_templates.merge (template_path, new_context, output)
				end
			end
		end

feature {NONE} -- Internal attributes

	template_name_variable_ref: EVOLICITY_VARIABLE_REFERENCE

end