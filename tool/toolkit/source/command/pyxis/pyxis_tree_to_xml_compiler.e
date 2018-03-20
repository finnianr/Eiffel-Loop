note
	description: "[
		Command to compile tree of UTF-8 encoded Pyxis source files into single XML file
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 11:27:12 GMT (Thursday 22nd February 2018)"
	revision: "7"

class
	PYXIS_TREE_TO_XML_COMPILER

inherit
	EL_PYXIS_TREE_COMPILER
		rename
			make as make_compiler
		end

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
			converter: EL_PYXIS_XML_TEXT_GENERATOR; xml_out: EL_PLAIN_TEXT_FILE
		do
			create xml_out.make_open_write (output_file_path)
			xml_out.enable_bom
			create converter.make
			lio.put_new_line
			lio.put_path_field ("Compiling", output_file_path)
			lio.put_line (" ..")
			converter.convert_lines (merged_lines, xml_out)
			xml_out.close
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
