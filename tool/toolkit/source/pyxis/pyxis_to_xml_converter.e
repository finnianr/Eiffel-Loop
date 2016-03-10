note
	description: "Summary description for {PYXIS_TO_XML_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:27 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	PYXIS_TO_XML_CONVERTER

inherit
	EL_COMMAND

	EL_MODULE_LOG

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATTION} -- Initialization

	make (a_source_path, a_output_path: EL_FILE_PATH)
		local
			extension: EL_ASTRING
		do
			source_path  := a_source_path
			output_path := a_output_path
			create xml_generator.make

			if output_path.is_empty then
				extension := source_path.extension
				if extension.same_string ("pecf") then
					output_path := source_path.with_new_extension ("ecf")
				else
					output_path := source_path.without_extension
				end
			end

		end

feature -- Basic operations

	execute
			--
		local
			out_file, in_file: PLAIN_TEXT_FILE
		do
			log.enter ("run")
			log_or_io.put_path_field ("Converting", source_path)
			log_or_io.put_new_line

			create in_file.make_open_read (source_path.unicode)
			create out_file.make_open_write (output_path.unicode)
			xml_generator.convert_stream (in_file, out_file)
			in_file.close
			out_file.close
			log.exit
		end

feature {NONE} -- Implementation

	source_path: EL_FILE_PATH

	output_path: EL_FILE_PATH

	xml_generator: EL_PYXIS_XML_TEXT_GENERATOR

end
