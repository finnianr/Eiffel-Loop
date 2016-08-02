note
	description: "[
		Compile tree of Pyxis source files into single XML file
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 7:22:11 GMT (Friday 8th July 2016)"
	revision: "1"

class
	PYXIS_COMPILER

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_OS

	EL_MODULE_FILE_SYSTEM

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_source_tree_path: EL_DIR_PATH; a_output_file_path: EL_FILE_PATH)
		do
			source_tree_path  := a_source_tree_path
			output_file_path := a_output_file_path
			if output_file_path.exists then
				output_modification_time := output_file_path.modification_time
			else
				create output_modification_time.make (0, 0, 0, 0, 0, 0)
			end
		end

feature -- Basic operations

	execute
			--
		local
			pyxis_in: like merged_text; converter: EL_PYXIS_XML_TEXT_GENERATOR
			xml_out: EL_PLAIN_TEXT_FILE; source_changed: BOOLEAN
		do
			log.enter ("execute")
			source_changed := across pyxis_file_path_list as file_path some
										file_path.item.modification_time > output_modification_time
									end
			if source_changed then
				pyxis_in := merged_text
				pyxis_in.open_read
				create xml_out.make_open_write (output_file_path)
				xml_out.enable_bom
				create converter.make
				lio.put_new_line
				lio.put_line ("Compiling ..")
				converter.convert_stream (pyxis_in, xml_out)
				pyxis_in.close; xml_out.close
			else
				lio.put_line ("Source has not changed")
			end
			log.exit
		end

feature {NONE} -- Implementation

	merged_text: EL_UTF_STRING_8_IO_MEDIUM
		local
			pyxis_source: STRING; start_index: INTEGER; path_list: like pyxis_file_path_list
			count: INTEGER
		do
			log.enter ("merged_text")
			path_list := pyxis_file_path_list
			across path_list as source_path loop
				count := count + File_system.file_byte_count (source_path.item)
			end
			create Result.make_open_write ((count * Pyxis_to_xml_size_scalar).rounded)
			-- Merge Pyxis files into one monolithic file
			lio.put_line ("Merging")
			across path_list as source_path loop
				lio.put_path_field ("Pyxis", source_path.item)
				lio.put_new_line
				pyxis_source := File_system.plain_text (source_path.item)
				if source_path.cursor_index = 1 then
					Result.put_encoded_string_8 (pyxis_source)
				else
					-- Skip to first item
					start_index := pyxis_source.substring_index ("%Titem:", 1)
					if start_index > 0 then
						Result.put_encoded_string_8 (pyxis_source.substring (start_index, pyxis_source.count))
					end
				end
				Result.put_new_line
			end
			Result.close
			log.exit
		end

	pyxis_file_path_list: like OS.file_list
		do
			Result := OS.file_list (source_tree_path, "*.pyx")
		end

feature {NONE} -- Internal attributes

	output_file_path: EL_FILE_PATH

	output_modification_time: DATE_TIME

	source_tree_path: EL_DIR_PATH

feature {NONE} -- Constants

	Pyxis_to_xml_size_scalar: REAL = 1.3

end