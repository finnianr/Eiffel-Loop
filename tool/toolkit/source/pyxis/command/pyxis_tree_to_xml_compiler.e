note
	description: "[
		Command to compile tree of UTF-8 encoded Pyxis source files into single XML file
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-06 8:25:54 GMT (Wednesday 6th May 2020)"
	revision: "9"

class
	PYXIS_TREE_TO_XML_COMPILER

inherit
	EL_PYXIS_TREE_COMPILER
		rename
			make as make_compiler
		end

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_source_tree_path: EL_DIR_PATH; a_output_file_path: EL_FILE_PATH)
		do
			make_compiler (a_source_tree_path)
			output_file_path := a_output_file_path
		end

feature {NONE} -- Implementation

	compile_tree
		local
			converter: EL_PYXIS_XML_TEXT_GENERATOR
		do
			create converter.make
			if attached open (output_file_path, Write) as xml_out then
				xml_out.byte_order_mark.enable
				lio.put_new_line
				lio.put_path_field ("Compiling", output_file_path)
				lio.put_line (" ..")
				converter.convert_lines (merged_lines, xml_out)
				close_open
			end
		ensure then
			files_closed: all_closed
		end

	new_output_modification_time: DATE_TIME
		do
			if output_file_path.exists then
				Result := output_file_path.modification_date_time
			else
				Result := Zero_time
			end
		end

feature {NONE} -- Internal attributes

	output_file_path: EL_FILE_PATH

end
