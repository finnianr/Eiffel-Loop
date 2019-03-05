note
	description: "Pyxis to xml converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-05 10:00:23 GMT (Tuesday 5th March 2019)"
	revision: "11"

class
	PYXIS_TO_XML_CONVERTER

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_source_path, a_output_path: EL_FILE_PATH)
		do
			source_path  := a_source_path; output_path := a_output_path
			if output_path.is_empty then
				if source_path.has_extension (Pecf) then
					output_path := source_path.with_new_extension ("ecf")
				else
					output_path := source_path.without_extension
					if not output_path.base.has ('.') then
						output_path.add_extension ("xml")
					end
				end
			else
				File_system.make_directory (a_output_path.parent)
			end
			if source_path.has_extension (Pecf) then
				create {ECF_XML_GENERATOR} xml_generator.make
			else
				create xml_generator.make
			end
		end

feature -- Basic operations

	execute
			--
		local
			in_file: PLAIN_TEXT_FILE; out_file: EL_PLAIN_TEXT_FILE
			encoding: EL_PYXIS_ENCODING
		do
			log.enter ("run")

			create encoding.make_from_file (source_path)

			lio.put_path_field ("Converting " + encoding.name, source_path)
			lio.put_new_line

			create in_file.make_open_read (source_path)

			if output_path.exists then
				File_system.remove_file (output_path)
			end

			create out_file.make_open_write (output_path)
			out_file.enable_bom
			out_file.set_encoding_from_other (encoding)

			xml_generator.convert_stream (in_file, out_file)
			in_file.close
			out_file.close
			log.exit
		end

feature {NONE} -- Implementation

	output_path: EL_FILE_PATH

	source_path: EL_FILE_PATH

	xml_generator: EL_PYXIS_XML_TEXT_GENERATOR

feature {NONE} -- Constants

	Pecf: ZSTRING
		once
			Result := "pecf"
		end
end
