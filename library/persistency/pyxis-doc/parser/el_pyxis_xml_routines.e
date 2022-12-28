note
	description: "Pyxis xml routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 10:28:18 GMT (Wednesday 28th December 2022)"
	revision: "21"

class
	EL_PYXIS_XML_ROUTINES

inherit
	ANY

	EL_MODULE_FILE

	EL_FILE_OPEN_ROUTINES

feature -- Status query

	is_pyxis_file (a_pyxis_file_path: FILE_PATH): BOOLEAN
		do
			Result := File.line_one (a_pyxis_file_path).starts_with ("pyxis-doc:")
		end

feature -- Basic operations

	convert_to_xml (a_pyxis_file_path: FILE_PATH; xml_out: IO_MEDIUM)
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

	attribute_type (field: EL_REFLECTED_FIELD): INTEGER
		do
			if attached {EL_REFLECTED_BOOLEAN} field or else attached {EL_REFLECTED_BOOLEAN_REF} field then
				Result := Type_boolean

			elseif attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} field as expanded_field then
				if expanded_field.has_string_representation then
					Result := Type_represented
				else
					Result := Type_expanded
				end
			end
		end

	encoding (file_path: FILE_PATH): EL_MARKUP_ENCODING
		do
			create Result.make_from_file (file_path)
		end

	root_element (file_path: FILE_PATH): ZSTRING
		local
			done: BOOLEAN; s: EL_ZSTRING_ROUTINES
		do
			create Result.make_empty
			if attached open_lines (file_path, {EL_ENCODING_CONSTANTS}.Latin_1) as lines then
				from lines.start until done or lines.after loop
					lines.item.right_adjust
					if lines.index = 1 then
						if not lines.item.starts_with_zstring (Pyxis_doc) then
							done := True
						end
					elseif lines.item.ends_with_zstring (s.character_string (':')) then
						Result := lines.item
						Result.remove_tail (1)
						done := True
					end
					lines.forth
				end
				lines.close
			end
		end

	root_element_name (xml: READABLE_STRING_GENERAL): STRING
		local
			found: BOOLEAN; i, pos_new_line, pos_colon: INTEGER; line: READABLE_STRING_GENERAL
		do
			from until found loop
				pos_new_line := xml.index_of ('%N', i + 1)
				if pos_new_line > 0 then
					line := xml.substring (i + 1, pos_new_line - 1)
					pos_colon := line.index_of (':', 1)
					if i > 0 and then pos_colon > 0 and then not (line [1] = '#' or line [1] = '%T') then
						Result := line.substring (1, pos_colon - 1).to_string_8
						found := True
					end
					i := pos_new_line
				else
					found := True
					create Result.make_empty
				end
			end
		end

	root_element_name_for_type (type: TYPE [EL_REFLECTIVELY_SETTABLE]): STRING
		do
			Result := type.name + "_list"
			Result.to_lower
		end

	to_utf_8_xml (a_pyxis_file_path: FILE_PATH): STRING
		local
			xml_out: EL_STRING_8_IO_MEDIUM
		do
			create xml_out.make_open_write (File.byte_count (a_pyxis_file_path))
			convert_to_xml (a_pyxis_file_path, xml_out)
			xml_out.close
			Result := xml_out.text
		end

	to_xml (a_pyxis_file_path: FILE_PATH): ZSTRING
		local
			xml_out: EL_ZSTRING_IO_MEDIUM
		do
			create xml_out.make_open_write (File.byte_count (a_pyxis_file_path))
			convert_to_xml (a_pyxis_file_path, xml_out)
			xml_out.close
			Result := xml_out.text
		end

feature -- Constants

	Type_boolean: INTEGER = 1

	Type_expanded: INTEGER = 2

	Type_represented: INTEGER = 3

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