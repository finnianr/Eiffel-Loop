note
	description: "Scripted file tree transformer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-11 12:20:10 GMT (Tuesday 11th September 2018)"
	revision: "1"

class
	FILE_TREE_TRANSFORMER_SCRIPT

inherit
	EL_FILE_TREE_TRANSFORMER
		rename
			make as make_transformer
		redefine
			make_default
		end

	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		export
			{EL_COMMAND_CLIENT} make
		redefine
			make_default, building_action_table
		end

	EL_COMMAND

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create command_template.make_empty
			Precursor {EL_FILE_TREE_TRANSFORMER}
			Precursor {EL_BUILDABLE_FROM_PYXIS}
		end

feature -- Basic operations

	execute
		local
			has_parameters: BOOLEAN; command: FILE_INPUT_OUTPUT_OS_COMMAND
		do
			has_parameters := True
			across Template_parameters as param until not has_parameters loop
				if not command_template.has_substring (param.item) then
					lio.put_labeled_string ("ERROR - Missing command parameter",  param.item)
					lio.put_new_line
					has_parameters := False
				end
			end
			if has_parameters then
				create command.make (command_template)
				if input_dir.exists then
					apply (command)
				else
					lio.put_line ("ERROR")
					lio.put_path_field ("Missing", input_dir)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Internal attributes

	command_template: STRING

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["command-template/text()",	agent do command_template.copy (node.to_string_8) end],
				["input-dir/text()",		 		agent do input_dir := node.to_expanded_dir_path end],
				["output-dir/text()",		 	agent do output_dir := node.to_expanded_dir_path end],
				["extension-list/text()",		agent do extension_list.extend (node.to_string_8) end]
			>>)
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "transform-tree"

	Template_parameters: ARRAY [STRING]
		once
			Result := << "$input_path", "$output_path" >>
		end

end
