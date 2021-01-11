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
	date: "2021-01-10 15:06:38 GMT (Sunday 10th January 2021)"
	revision: "27"

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

	PYXIS_ATTRIBUTE_PARSER_TEST_DATA
		export
			{NONE} all
		undefine
			default_create
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
--			eval.call ("attribute_parser", agent test_attribute_parser)
			eval.call ("conversion_to_xml", agent test_conversion_to_xml)
		end

feature -- Tests

	test_attribute_parser
		note
			testing: "covers/{EL_PYXIS_ATTRIBUTE_PARSER}.parse"
		local
			parser: EL_PYXIS_ATTRIBUTE_PARSER; table: like Attribute_table; name: STRING
			attribute_list: EL_ELEMENT_ATTRIBUTE_LIST; l_attribute: EL_ELEMENT_ATTRIBUTE_NODE_STRING
		do
			create attribute_list.make
			create parser.make (attribute_list)
			parser.set_source_text (Attributes_source_line)
			parser.parse
			create table.make_equal (5)
			across attribute_list as list loop
				l_attribute := list.item
				name := l_attribute.name
				if l_attribute.is_integer then
					table [name] := l_attribute.to_integer
				elseif l_attribute.is_double then
					table [name] := l_attribute.to_double
				elseif l_attribute.is_boolean then
					table [name] := l_attribute.to_boolean
				else
					table [name] := l_attribute.to_string_8
				end
			end
			assert ("pyxis_parser OK", table ~ Attribute_table)

			attribute_list.reset
			parser.set_source_text_from_substring (Pyxis_encoding, 2, Pyxis_encoding.count)
			parser.parse
			assert ("is version", attribute_list.first.name.same_string ("version"))
			assert ("is encoding", attribute_list.last.name.same_string ("encoding"))
			parser.parse
		end

	test_conversion_to_xml
			--
		local
			name, file_name: STRING; checksum: NATURAL
		do
			name := "convert_pyxis_to_xml"
			-- 3 Feb 2020
			across file_list as file_path loop
				file_name := file_path.item.base
				do_test (name, Checksum_table [file_name], agent convert_pyxis_to_xml, [file_path.item])
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
			create source.make (converter.source_encoding.encoding, converter.output_path)
			source.print_first (log, 20)
			source.close
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (EL_test_data_dir.joined_dir_path ("pyxis"), "*.pyx")
		end

feature {NONE} -- Constants

	Pyxis_encoding: STRING = "%Tversion = 1.0; encoding = %"ISO-8859-1%""

	Checksum_table: EL_HASH_TABLE [NATURAL, STRING]
		once
			create Result.make_equal (11)
			Result ["build.eant.pyx"] := 2189551509
			Result ["configuration.xsd.pyx"] := 3726265964
			Result ["credits.pyx"] := 2407875608
			Result ["phrases.pyx"] := 201032556
			Result ["words.pyx"] := 3549002455
			Result ["XML XSL Example.xsl.pyx"] := 789114879
		end

end