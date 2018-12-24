note
	description: "[
		Script that applies command template to every file in a directory tree that has specified extensions
	]"
	notes: "[
		Example script to do image resizing using ImageMagick tool `convert'

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			transform-tree:
				command-template:
					"convert -resize 630 $input_path $output_path"

				input-dir:
					"$HOME/Graphics/screenshot/en/thumbnail"

				output-dir:
					"$HOME/Desktop"
					
				extension-list:
					"png"
					
		**Optional**
				output-extension:
					"xxx"


	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 13:20:57 GMT (Sunday 23rd December 2018)"
	revision: "4"

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
		redefine
			make_default, building_action_table
		end

	EL_COMMAND

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_input: EL_INPUT_PATH [EL_FILE_PATH])
		do
			a_input.check_path ("Drag and drop a Pyxis transform script")
			make_from_file (a_input.path)
		end

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
				["output-extension/text()",	agent do output_extension.share (node.to_string_8) end],
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
