note
	description: "Summary description for {EL_PYXIS_XML_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-03 11:17:42 GMT (Wednesday 3rd July 2013)"
	revision: "4"

class
	EL_PYXIS_XML_ROUTINES

inherit
	EL_XML_ROUTINES
		redefine
			Predefined_entities_sans_quote
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

create
	default_create

feature -- Access

	to_xml (a_pyxis_file_path: EL_FILE_PATH): STRING
		require
			is_pyxis_file: is_pyxis_file (a_pyxis_file_path)
		local
			xml_generator: EL_PYXIS_XML_TEXT_GENERATOR
			xml_out: EL_TEXT_IO_MEDIUM
			pyxis_in: PLAIN_TEXT_FILE
		do
			create pyxis_in.make_open_read (a_pyxis_file_path.unicode)
			create xml_out.make_open_write (pyxis_in.count * pyxis_in.count // 4)

			create xml_generator.make
			xml_generator.convert_stream (pyxis_in, xml_out)
			pyxis_in.close

			Result := xml_out.text
		end

	is_pyxis_file (a_pyxis_file_path: EL_FILE_PATH): BOOLEAN
		do
			Result := File_system.line_one (a_pyxis_file_path).starts_with ("pyxis-doc:")
		end

feature {NONE} -- Constants

	Predefined_entities_sans_quote: EL_HASH_TABLE [EL_ASTRING, NATURAL]
		once
			Result := Precursor.twin
			Result [Tab_code] := escape_sequence (Tab_code)
		end

	Tab_code: NATURAL
		once
			Result := ('%T').natural_32_code
		end

end
