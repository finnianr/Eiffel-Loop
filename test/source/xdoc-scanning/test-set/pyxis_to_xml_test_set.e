note
	description: "Test class [$source EL_PYXIS_TO_XML_CONVERTER] from library `xdoc-scanning.ecf'"
	notes: "[
		Test sets conforming to [$source EL_EQA_REGRESSION_TEST_SET] (like this one) can only be run
		from a sub-application conforming to [$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-09 10:55:05 GMT (Sunday 9th February 2020)"
	revision: "22"

class
	PYXIS_TO_XML_TEST_SET

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

	test_conversion
			--
		local
			name: STRING; checksum: NATURAL
		do
			name := "convert_pyxis_to_xml"
			-- 3 Feb 2020
			across file_list as file_path loop
				inspect file_path.cursor_index
					when 1 then checksum := 3087401815 -- build.eant.pyx
					when 2 then checksum := 3875516187 -- configuration.xsd.pyx
					when 3 then checksum := 2431308370 -- localization/credits.pyx
					when 4 then checksum := 3713473313 -- localization/phrases.pyx
					when 5 then checksum := 3350160703 -- localization/words.pyx
					when 6 then checksum := 1726298027 -- XML XSL Example.xsl.pyx
					when 7 then checksum := 0
					when 8 then checksum := 0
					when 9 then checksum := 0
				else
				end
				do_test (name, checksum, agent convert_pyxis_to_xml, [file_path.item])
			end
		end

feature {NONE} -- Implementation

	convert_pyxis_to_xml (a_file_path: EL_FILE_PATH)
			--
		local
			converter: EL_PYXIS_TO_XML_CONVERTER; source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create converter.make (a_file_path, create {EL_FILE_PATH})
			converter.execute
			create source.make_encoded (converter.source_encoding, converter.output_path)
			source.print_first (log, 20)
			source.close
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (EL_test_data_dir.joined_dir_path ("pyxis"), "*.pyx")
		end

end
