note
	description: "Test class [$source EL_XML_TO_PYXIS_CONVERTER] from library `vtd-xml.ecf'"
	notes: "[
		Test sets conforming to [$source EL_EQA_REGRESSION_TEST_SET] (like this one) can only be run
		from a sub-application conforming to [$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-09 10:55:53 GMT (Sunday 9th February 2020)"
	revision: "2"

class
	XML_TO_PYXIS_CONVERTER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as Eiffel_loop_dir
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

feature -- Basic operations

	test_conversions
		local
			name: STRING; checksum: NATURAL
		do
			name := "convert_xml_to_pyxis"
			-- 6 Feb 2020
			across file_list as file_path loop
				inspect file_path.cursor_index
					when 1 then checksum := 3911484504 -- XML/Rhythmbox.bkup
					when 2 then checksum := 1751456571 -- XML/uuid.ecf
					when 3 then checksum := 827090613  -- XML/XML XSL Example.xsl
					when 4 then checksum := 2652949353 -- XML/configuration.xsd
					when 5 then checksum := 2906511580 -- XML/kernel.xace
					when 7 then checksum := 0
					when 8 then checksum := 0
					when 9 then checksum := 0
				else
				end
				do_test (name, checksum, agent convert_xml_to_pyxis, [file_path.item])
			end
		end
feature {NONE} -- Implementation

	convert_xml_to_pyxis (file_path: EL_FILE_PATH)
			--
		local
			converter: EL_XML_TO_PYXIS_CONVERTER; source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create converter.make (file_path)
			converter.execute
			create source.make_encoded (converter.source_encoding, converter.output_path)
			source.print_first (log, 20)
			source.close
		end

	source_file_list: EL_FILE_PATH_LIST
		local
			list: EL_FILE_PATH_LIST; filter: STRING
		do
			across << "bkup", "ecf", "xsl", "xsd", "xace" >> as extension loop
				filter := "*." + extension.item
				if extension.cursor_index = 1 then
					Result := OS.file_list (XML_dir, filter)
				else
					Result.append (OS.file_list (XML_dir, filter))
				end
			end
		end

feature {NONE} -- Constants

	XML_dir: EL_DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_path ("XML")
		end
end
