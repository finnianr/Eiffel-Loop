note
	description: "[
		Compile tree of Pyxis source files into single XML file
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PYXIS_COMPILER

inherit
	EL_COMMAND

	EL_MODULE_LOG

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
			pyxis_in: EL_TEXT_IO_MEDIUM; converter: EL_PYXIS_XML_TEXT_GENERATOR
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
				create converter.make
				log_or_io.put_new_line
				log_or_io.put_line ("Compiling ..")
				converter.convert_stream (pyxis_in, xml_out)
				pyxis_in.close; xml_out.close
			else
				log_or_io.put_line ("Source has not changed")
			end
			log.exit
		end

feature {NONE} -- Implementation

	merged_text: EL_TEXT_IO_MEDIUM
		local
			pyxis_source: STRING
			start_index: INTEGER
		do
			log.enter ("merged_text")
			create Result.make_open_write (1024)
			-- Merge Pyxis files into one monolithic file
			log_or_io.put_line ("Merging")
			across pyxis_file_path_list as source_path loop
				log_or_io.put_path_field ("Pyxis", source_path.item)
				log_or_io.put_new_line
				pyxis_source := File_system.plain_text (source_path.item)
				if source_path.cursor_index = 1 then
					Result.put_string (pyxis_source)
				else
					-- Skip to first item
					start_index := pyxis_source.substring_index ("%Titem:", 1)
					if start_index > 0 then
						Result.put_string (pyxis_source.substring (start_index, pyxis_source.count))
					end
				end
				Result.put_new_line
			end
			Result.close
			log.exit
		end

	pyxis_file_path_list: like File_system.file_list
		do
			Result := File_system.file_list (source_tree_path, "*.pyx")
		end

feature {NONE} -- Internal attributes

	output_modification_time: DATE_TIME

	output_file_path: EL_FILE_PATH

	source_tree_path: EL_DIR_PATH

end
