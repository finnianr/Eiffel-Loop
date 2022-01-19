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
	date: "2022-01-19 9:46:10 GMT (Wednesday 19th January 2022)"
	revision: "13"

class
	XML_TO_PYXIS_CONVERTER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as Eiffel_loop_dir
		undefine
			new_lio
		end

	EL_CRC_32_TEST_ROUTINES

	EIFFEL_LOOP_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("conversions",	agent test_conversions)
		end

feature -- Tests

	test_conversions
		local
			name, file_name: STRING; checksum: NATURAL
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

	Checksum_table: HASH_TABLE [NATURAL, STRING]
		once
			create Result.make (11)
			Result ["Rhythmbox.bkup"] := 1739055524
			Result ["uuid.ecf"] := 927586798
			Result ["XML XSL Example.xsl"] := 414472077
			Result ["configuration.xsd"] := 2399956695
			Result ["kernel.xace"] := 2157100131
		end

	XML_dir: DIR_PATH
		once
			Result := EL_test_data_dir #+ "XML"
		end
end