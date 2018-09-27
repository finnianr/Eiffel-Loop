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
	date: "2018-09-20 16:19:49 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_FILE_TREE_TRANSFORMER

inherit
	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_input_dir, a_output_dir: EL_DIR_PATH; extensions: STRING)
			-- `extensions' is a semi-colon separated list of file extensions
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
			create output_extension.make_empty
			create extension_list.make (3)
		end

feature -- Basic operations

	apply (command: EL_FILE_INPUT_OUTPUT_COMMAND_I)
		-- apply file transformation `command' on each file in `input_dir' with extension in `extension_list'
		-- placing output in `output_dir'
		local
			input_path, output_path: EL_FILE_PATH
			file_list: LIST [EL_FILE_PATH]; file_updated: BOOLEAN
		do
			across extension_list as extension loop
				file_list := File_system.recursive_files_with_extension (input_dir, extension.item)
				if file_list.is_empty then
					if is_lio_enabled then
						lio.put_path_field ("No files *." + extension.item + " in", input_dir)
						lio.put_new_line
					end
				else
					file_updated := False
					across file_list as path loop
						input_path := path.item
						output_path := output_dir + input_path.relative_path (input_dir)
						if not output_extension.is_empty then
							output_path.replace_extension (output_extension)
						end
						if File_system.is_file_newer (input_path, output_path) then
							File_system.make_directory (output_path.parent)
							if is_lio_enabled then
								lio.put_path_field ("Writing", output_path)
								lio.put_new_line
							end
							file_updated := True
							command.set_input_output_path (input_path, output_path)
							command.execute
						end
					end
					if not file_updated then
						lio.put_substitution ("No change in any of %S %S source files", [file_list.count, extension.item])
						lio.put_new_line
					end
				end
			end
		end

feature -- Element change

	set_output_extension (a_output_extension: like output_extension)
		do
			output_extension.share (a_output_extension)
		end

feature {NONE} -- Internal attributes

	extension_list: ARRAYED_LIST [STRING]

	input_dir: EL_DIR_PATH

	output_dir: EL_DIR_PATH

	output_extension: STRING

feature {NONE} -- Constants

	Extension_separator: CHARACTER = ';'

end
