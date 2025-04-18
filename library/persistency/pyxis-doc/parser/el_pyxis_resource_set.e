note
	description: "[
		Object for caching XML conversions of resource set in Pyxis format installed in application directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 7:56:20 GMT (Wednesday 16th April 2025)"
	revision: "17"

class
	EL_PYXIS_RESOURCE_SET

inherit
	EL_MODULE_DIRECTORY; EL_MODULE_FILE_SYSTEM; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_PYXIS

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		export
			{NONE} all
		end

create
	make, make_monolithic

feature {NONE} -- Initialization

	make (a_directory_name: like directory_name)
		local
			xml_file_path: FILE_PATH; xml_out: EL_PLAIN_TEXT_FILE
			pyxis_file_paths: like xml_file_paths
		do
			make_machine
			directory_name := a_directory_name
			pyxis_file_paths := File_system.files_with_extension (pyxis_source_dir, "pyx", True)
			create xml_file_paths.make (pyxis_file_paths.count)
			across pyxis_file_paths as pyxis_file_path loop
				xml_file_path := xml_destination_dir.plus_file (pyxis_file_path.item.base).with_new_extension ("xml")
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
			pyxis_lines: EL_PLAIN_TEXT_LINE_SOURCE; pyxis_out: PLAIN_TEXT_FILE
			monolithic_pyxis_path: FILE_PATH; xml_out: EL_PLAIN_TEXT_FILE
			pyxis_file_paths: like xml_file_paths
		do
			make_machine
			directory_name := a_directory_name
			monolithic_pyxis_path := Directory.app_configuration + directory_name
			monolithic_pyxis_path.add_extension ("pyx")
			create xml_file_paths.make_from_array (<< monolithic_pyxis_path.with_new_extension ("xml") >>)

			pyxis_file_paths := File_system.files_with_extension (pyxis_source_dir, "pyx", True)
			if pyxis_file_paths.first.modification_time > monolithic_xml_file_path.modification_time then
				create pyxis_out.make_open_write (monolithic_pyxis_path)
				across pyxis_file_paths as pyxis_file_path loop
					create pyxis_lines.make_utf_8 (pyxis_file_path.item)
					do_with_lines (agent find_root_element (?, pyxis_out, pyxis_file_path.cursor_index = 1), pyxis_lines)
				end
				pyxis_out.close
			end
			create xml_out.make_open_write (monolithic_xml_file_path)
			Pyxis.convert_to_xml (monolithic_pyxis_path, xml_out)
			xml_out.close
		end

feature -- Access

	monolithic_xml_file_path: FILE_PATH
		do
			Result := xml_file_paths.first
		end

	xml_file_paths: ARRAYED_LIST [FILE_PATH]

feature {NONE} -- Line states

	extend (line: ZSTRING; pyxis_out: PLAIN_TEXT_FILE)
		local
			buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			pyxis_out.put_string (buffer.copied_general (line))
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

	pyxis_source_dir: DIR_PATH
		do
			Result := Directory.Application_installation #+ directory_name
		end

	xml_destination_dir: DIR_PATH
		do
			Result := Directory.app_configuration #+ directory_name
		end

feature {NONE} -- Constants

	Pyxis_doc: ZSTRING
		once
			Result :=  "pyxis-doc:"
		end
end