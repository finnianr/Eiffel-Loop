note
	description: "[
		Object to transform selected input files placing the results in a created output directory
		with matching structure. The conversion is carrried out by a supplied argument to routine `do_all'
		conforming to [$source EL_FILE_INPUT_OUTPUT_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-11 11:09:40 GMT (Tuesday 11th September 2018)"
	revision: "1"

class
	EL_FILE_TREE_TRANSFORMER

inherit
	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_input_dir, a_output_dir: EL_DIR_PATH; extensions: STRING)
		require
			valid_input_dir: a_input_dir.exists
		do
			make_default
			input_dir.copy (a_input_dir); output_dir.copy (a_output_dir)
			extensions.split (Extension_separator).do_all (agent extension_list.extend)
		end

	make_default
		do
			create input_dir
			create output_dir
			create extension_list.make (3)
		end

feature -- Basic operations

	apply (command: EL_FILE_INPUT_OUTPUT_COMMAND_I)
		-- apply file transformation `command' on each file in `input_dir' with extension in `extension_list'
		-- placing output in `output_dir'
		local
			input_path, output_path: EL_FILE_PATH
			file_list: LIST [EL_FILE_PATH]
		do
			across extension_list as extension loop
				file_list := File_system.recursive_files_with_extension (input_dir, extension.item)
				if file_list.is_empty then
					if is_lio_enabled then
						lio.put_path_field ("No files *." + extension.item + " in", input_dir)
						lio.put_new_line
					end
				else
					across file_list as path loop
						input_path := path.item
						output_path := output_dir + input_path.relative_path (input_dir)
						File_system.make_directory (output_path.parent)
						if is_lio_enabled then
							lio.put_path_field ("Writing", output_path)
							lio.put_new_line
						end
						command.set_input_output_path (input_path, output_path)
						command.execute
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	extension_list: ARRAYED_LIST [STRING]

	input_dir: EL_DIR_PATH

	output_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Extension_separator: CHARACTER = ';'

end
