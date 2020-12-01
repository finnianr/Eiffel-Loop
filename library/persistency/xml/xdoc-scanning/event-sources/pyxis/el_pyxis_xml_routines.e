note
	description: "Pyxis xml routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-30 13:53:53 GMT (Monday 30th November 2020)"
	revision: "11"

class
	EL_PYXIS_XML_ROUTINES

inherit
	ANY

	EL_MODULE_FILE_SYSTEM

	EL_FILE_OPEN_ROUTINES

	EL_ZSTRING_CONSTANTS

feature -- Status query

	is_pyxis_file (a_pyxis_file_path: EL_FILE_PATH): BOOLEAN
		do
			Result := File_system.line_one (a_pyxis_file_path).starts_with ("pyxis-doc:")
		end

feature -- Basic operations

	convert_to_xml (a_pyxis_file_path: EL_FILE_PATH; xml_out: EL_OUTPUT_MEDIUM)
		require
			is_pyxis_file: is_pyxis_file (a_pyxis_file_path)
		local
			xml_generator: EL_PYXIS_XML_TEXT_GENERATOR
			pyxis_in: PLAIN_TEXT_FILE
		do
			create pyxis_in.make_open_read (a_pyxis_file_path)
			create xml_generator.make
			xml_generator.convert_stream (pyxis_in, xml_out)
			pyxis_in.close
		end

	put_header (output: EL_OUTPUT_MEDIUM)
		do
			output.put_string (Header_template #$ [output.encoding_name])
			output.put_new_line
		end

feature -- Access

	encoding (file_path: EL_FILE_PATH): EL_MARKUP_ENCODING
		do
			create Result.make_from_file (file_path)
		end

	root_element (file_path: EL_FILE_PATH): ZSTRING
		local
			done: BOOLEAN
		do
			create Result.make_empty
			if attached open_lines (file_path, Latin_1) as lines then
				from lines.start until done or lines.after loop
					lines.item.right_adjust
					if lines.index = 1 then
						if not lines.item.starts_with (Pyxis_doc) then
							done := True
						end
					elseif lines.item.ends_with (character_string (':')) then
						Result := lines.item
						Result.remove_tail (1)
						done := True
					end
					lines.forth
				end
				lines.close
			end
		end

	to_utf_8_xml (a_pyxis_file_path: EL_FILE_PATH): STRING
		local
			xml_out: EL_STRING_8_IO_MEDIUM
		do
			create xml_out.make_open_write (File_system.file_byte_count (a_pyxis_file_path))
			convert_to_xml (a_pyxis_file_path, xml_out)
			xml_out.close
			Result := xml_out.text
		end

	to_xml (a_pyxis_file_path: EL_FILE_PATH): ZSTRING
		local
			xml_out: EL_ZSTRING_IO_MEDIUM
		do
			create xml_out.make_open_write (File_system.file_byte_count (a_pyxis_file_path))
			convert_to_xml (a_pyxis_file_path, xml_out)
			xml_out.close
			Result := xml_out.text
		end

feature {NONE} -- Constants

	Pyxis_doc: ZSTRING
		once
			Result := "pyxis-doc:"
		end

	Header_template: ZSTRING
		once
			Result := "[
				pyxis-doc:
					version = 1.0; encoding = "#"
			]"
		end
end