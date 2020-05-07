note
	description: "Pyxis to xml converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-06 15:18:03 GMT (Wednesday 6th May 2020)"
	revision: "6"

class
	EL_PYXIS_TO_XML_CONVERTER

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_FILE_SYSTEM

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_source_path, a_output_path: EL_FILE_PATH)
		do
			source_path  := a_source_path; output_path := a_output_path
			create source_encoding.make_from_file (source_path)
			if output_path.is_empty then
				output_path := new_output_path
			else
				File_system.make_directory (a_output_path.parent)
			end
			xml_generator := new_xml_generator
		end

feature -- Access

	output_path: EL_FILE_PATH

	source_path: EL_FILE_PATH

	source_encoding: EL_MARKUP_ENCODING

feature -- Basic operations

	execute
			--
		do
			if is_lio_enabled then
				lio.put_path_field ("Converting " + source_encoding.name, source_path)
				lio.put_new_line
			end

			if attached open (source_path, Read) as in_file then
				if output_path.exists then
					File_system.remove_file (output_path)
				end
				if attached open (output_path, Write) as out_file then
					out_file.byte_order_mark.enable
					out_file.set_encoding_from_other (source_encoding)

					xml_generator.convert_stream (in_file, out_file)
					out_file.close
				end
				in_file.close
			end
		end

feature {NONE} -- Implementation

	new_output_path: EL_FILE_PATH
		do
			Result := source_path.without_extension
			if not Result.base.has ('.') then
				Result.add_extension ("xml")
			end
		end

	new_xml_generator: EL_PYXIS_XML_TEXT_GENERATOR
		do
			create Result.make
		end

feature {NONE} -- Internal attributes

	xml_generator: EL_PYXIS_XML_TEXT_GENERATOR

end
