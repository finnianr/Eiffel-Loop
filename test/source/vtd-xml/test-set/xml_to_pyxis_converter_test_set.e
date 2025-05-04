note
	description: "Test class ${EL_XML_TO_PYXIS_CONVERTER} from library `vtd-xml.ecf'"
	notes: "[
		Test sets conforming to ${EL_CRC_32_TESTABLE} (like this one) can only be run
		from a sub-application conforming to ${EL_CRC_32_AUTOTEST_APPLICATION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 21:14:45 GMT (Sunday 4th May 2025)"
	revision: "22"

class
	XML_TO_PYXIS_CONVERTER_TEST_SET

inherit
	COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["conversions",	agent test_conversions]
			>>)
		end

feature -- Tests

	test_conversions
		local
			name, file_name: STRING
		do
			name := "convert_xml_to_pyxis"
			-- 6 Feb 2020
			across file_list as file_path loop
				file_name := file_path.item.base
				do_test (name, Checksum_table [file_name], agent convert_xml_to_pyxis, [file_path.item])
			end
		end

feature {NONE} -- Implementation

	convert_xml_to_pyxis (file_path: FILE_PATH)
			--
		local
			converter: EL_XML_TO_PYXIS_CONVERTER; source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create converter.make (file_path)
			converter.execute
			create source.make (converter.source_encoding.encoding, converter.output_path)
			source.print_first (lio, 20)
			source.close
		end

	source_file_list: EL_FILE_PATH_LIST
		local
			list: EL_FILE_PATH_LIST; ext_filter: STRING
		do
			across << "bkup", "ecf", "xsl", "xsd", "xace" >> as extension loop
				ext_filter := "*." + extension.item
				if extension.cursor_index = 1 then
					Result := OS.file_list (xml_dir, ext_filter)
				else
					Result.append (OS.file_list (xml_dir, ext_filter))
				end
			end
		end

	xml_dir: DIR_PATH
		do
			Result := Data_dir.xml
		end

feature {NONE} -- Constants

	Checksum_table: HASH_TABLE [NATURAL, STRING]
		once
			create Result.make (11)
			Result ["Rhythmbox.bkup"] := 1739055524
			Result ["uuid.ecf"] := 927586798
			Result ["XML XSL Example.xsl"] := 414472077
			Result ["configuration.xsd"] := 2399956695
			Result ["kernel.xace"] := 2157100131
		end

end