note
	description: "Pyxis to xml converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 13:21:21 GMT (Saturday 11th January 2020)"
	revision: "1"

class
	EL_PYXIS_TO_XML_CONVERTER

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_FILE_SYSTEM

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_source_path, a_output_path: EL_FILE_PATH)
		do
			source_path  := a_source_path; output_path := a_output_path
			if output_path.is_empty then
				output_path := new_output_path
			else
				File_system.make_directory (a_output_path.parent)
			end
			xml_generator := new_xml_generator
		end

feature -- Basic operations

	execute
			--
		local
			in_file: PLAIN_TEXT_FILE; out_file: EL_PLAIN_TEXT_FILE
			encoding: EL_PYXIS_ENCODING
		do
			create encoding.make_from_file (source_path)

			if is_lio_enabled then
				lio.put_path_field ("Converting " + encoding.name, source_path)
				lio.put_new_line
			end

			create in_file.make_open_read (source_path)

			if output_path.exists then
				File_system.remove_file (output_path)
			end

			create out_file.make_open_write (output_path)
			out_file.byte_order_mark.enable
			out_file.set_encoding_from_other (encoding)

			xml_generator.convert_stream (in_file, out_file)
			in_file.close
			out_file.close
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

	output_path: EL_FILE_PATH

	source_path: EL_FILE_PATH

	xml_generator: EL_PYXIS_XML_TEXT_GENERATOR

end
