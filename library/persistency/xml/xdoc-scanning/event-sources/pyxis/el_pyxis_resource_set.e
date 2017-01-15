note
	description: "[
		Object for caching XML conversions of resource set in Pyxis format installed in application directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-17 11:59:36 GMT (Thursday 17th November 2016)"
	revision: "2"

class
	EL_PYXIS_RESOURCE_SET

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_PYXIS

	EL_MODULE_FILE_SYSTEM

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		export
			{NONE} all
		end

	EL_MODULE_DIRECTORY

create
	make, make_monolithic

feature {NONE} -- Initialization

	make (a_directory_name: like directory_name)
		local
			xml_file_path: EL_FILE_PATH; xml_out: EL_PLAIN_TEXT_FILE
			pyxis_file_paths: like xml_file_paths
		do
			make_machine
			directory_name := a_directory_name
			pyxis_file_paths := File_system.recursive_files_with_extension (pyxis_source_dir, "pyx")
			create xml_file_paths.make (pyxis_file_paths.count)
			across pyxis_file_paths as pyxis_file_path loop
				xml_file_path := xml_destination_dir.joined_file_path (pyxis_file_path.item.base).with_new_extension ("xml")
				if pyxis_file_path.item.modification_time > xml_file_path.modification_time then
					File_system.make_directory (xml_file_path.parent)
					create xml_out.make_open_write (xml_file_path)
					Pyxis.convert_to_xml (pyxis_file_path.item, xml_out)
					xml_out.close
				end
				xml_file_paths.extend (xml_file_path)
			end
		end

	make_monolithic (a_directory_name: like directory_name)
			-- merge all Pyxis files into monolithic file
			-- Fatal crash when using this from EL_LOCALE_ROUTINES
		local
			pyxis_lines: EL_FILE_LINE_SOURCE
			pyxis_out: PLAIN_TEXT_FILE
			pyxis_file_paths: like xml_file_paths
			monolithic_pyxis_path: EL_FILE_PATH; xml_out: EL_PLAIN_TEXT_FILE
			xml_generator: EL_PYXIS_XML_TEXT_GENERATOR
		do
			make_machine
			directory_name := a_directory_name
			monolithic_pyxis_path := Directory.User_configuration + directory_name
			monolithic_pyxis_path.add_extension ("pyx")
			create xml_file_paths.make_from_array (<< monolithic_pyxis_path.with_new_extension ("xml") >>)

			pyxis_file_paths := File_system.recursive_files_with_extension (pyxis_source_dir, "pyx")
			if pyxis_file_paths.first.modification_time  > monolithic_xml_file_path.modification_time then
				create pyxis_out.make_open_write (monolithic_pyxis_path)
				across pyxis_file_paths as pyxis_file_path loop
					create pyxis_lines.make (pyxis_file_path.item)
					do_with_lines (agent find_root_element (?, pyxis_out, pyxis_file_path.cursor_index = 1), pyxis_lines)
				end
				pyxis_out.close
			end
			create xml_out.make_open_write (monolithic_xml_file_path)
			Pyxis.convert_to_xml (monolithic_pyxis_path, xml_out)
			xml_out.close
		end

feature -- Access

	monolithic_xml_file_path: EL_FILE_PATH
		do
			Result := xml_file_paths.first
		end

	xml_file_paths: ARRAYED_LIST [EL_FILE_PATH]

feature {NONE} -- Line states

	extend (line: ZSTRING; pyxis_out: PLAIN_TEXT_FILE)
		do
			pyxis_out.put_string (line.to_utf_8)
			pyxis_out.put_new_line
		end

	find_root_element (line: ZSTRING; pyxis_out: PLAIN_TEXT_FILE; is_first: BOOLEAN)
		do
			if not line.is_empty
				and then (not line.starts_with (Pyxis_doc) and line [1] /= '#' and line.item (line.count) = ':')
			then
				state := agent extend (?, pyxis_out)
			end
			if is_first then
				extend (line, pyxis_out)
			end
		end

feature {NONE} -- Implementation

	directory_name: ZSTRING

	pyxis_source_dir: EL_DIR_PATH
		do
			Result := Directory.Application_installation.joined_dir_path (directory_name)
		end

	xml_destination_dir: EL_DIR_PATH
		do
			Result := Directory.User_configuration.joined_dir_path (directory_name)
		end

feature {NONE} -- Constants

	Pyxis_doc: ZSTRING
		once
			Result :=  "pyxis-doc:"
		end
end
