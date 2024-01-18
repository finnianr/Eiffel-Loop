note
	description: "[
		Object to transform selected input files placing the results in a created output directory
		with matching structure. The conversion is carrried out by a supplied argument to routine `do_all'
		conforming to ${EL_FILE_INPUT_OUTPUT_COMMAND}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-27 9:49:09 GMT (Sunday 27th November 2022)"
	revision: "12"

class
	EL_FILE_TREE_TRANSFORMER

inherit
	ANY

	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_input_dir, a_output_dir: DIR_PATH; extensions: STRING)
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
			input_path, output_path: FILE_PATH
			file_list: LIST [FILE_PATH]; file_updated: BOOLEAN
		do
			across extension_list as extension loop
				file_list := File_system.files_with_extension (input_dir, extension.item, True)
				if file_list.is_empty then
					if is_lio_enabled then
						lio.put_path_field ("No files *." + extension.item + " in %S", input_dir)
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
						if File.is_newer_than (input_path, output_path) then
							File_system.make_directory (output_path.parent)
							if is_lio_enabled then
								lio.put_path_field ("Writing %S", output_path)
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

	extension_list: EL_STRING_8_LIST

	input_dir: DIR_PATH

	output_dir: DIR_PATH

	output_extension: STRING

feature {NONE} -- Constants

	Extension_separator: CHARACTER = ';'

end