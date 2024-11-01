note
	description: "Test class ${EL_PYXIS_TO_XML_CONVERTER} from library `xdoc-scanning.ecf'"
	notes: "[
		Test sets conforming to ${EL_CRC_32_TESTABLE} (like this one) can only be run
		from a sub-application conforming to ${EL_CRC_32_AUTOTEST_APPLICATION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-31 10:41:43 GMT (Thursday 31st October 2024)"
	revision: "59"

class
	PYXIS_TO_XML_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as eiffel_loop_dir
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	SHARED_DEV_ENVIRON

	EL_SHARED_TEST_XDOC_DATA

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["attribute_parser",	 agent test_attribute_parser],
				["conversion_to_xml", agent test_conversion_to_xml]
			>>)
		end

feature -- Tests

	test_attribute_parser
		note
			testing: "covers/{EL_PYXIS_ATTRIBUTE_PARSER}.parse"
		local
			parser: EL_PYXIS_DOC_ATTRIBUTE_PARSER; table: like Xdoc.Attribute_table; name: STRING
			attribute_list: EL_ELEMENT_ATTRIBUTE_LIST; l_attribute: EL_ELEMENT_ATTRIBUTE_NODE_STRING
			document_dir: DIR_PATH
		do
			create document_dir
			create attribute_list.make (document_dir)
			create parser.make (attribute_list)
			parser.set_source_text (Xdoc.pyxis_attributes_line (Xdoc.Attribute_table))
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
			assert ("pyxis_parser OK", table ~ Xdoc.Attribute_table)

			attribute_list.reset
			parser.set_substring_source_text (Pyxis_encoding, 2, Pyxis_encoding.count)
			parser.parse
			assert_same_string ("is version", attribute_list.first.name, "version")
			assert_same_string ("is encoding", attribute_list.last.name, "encoding")
			parser.parse
		end

	test_conversion_to_xml
		-- PYXIS_TO_XML_TEST_SET.test_conversion_to_xml
		local
			file_name, style_text, style_xpath: STRING; checksum: NATURAL; xsl_doc: EL_XML_DOC_CONTEXT
			count: INTEGER
		do
			-- 3 Feb 2020
			across file_list as list loop
				if attached list.item as file_path and then Checksum_table.has_key (file_path.base) then
					do_test ("convert_pyxis_to_xml", Checksum_table.found_item, agent convert_pyxis_to_xml, [file_path])
					count := count + 1
					if file_path.same_base (XSL_example) then
						create xsl_doc.make_from_file (file_path.without_extension)
						style_xpath := "//style[@type='text/css']/text()"
						style_text := xsl_doc.query (style_xpath).as_string_8
						style_text.adjust
						assert ("verbatim text indentations preserved", style_text.occurrences ('%T') = 9)
					end
				end
			end
			assert ("All file founds", count = Checksum_table.count)
		end

feature {NONE} -- Implementation

	convert_pyxis_to_xml (a_file_path: FILE_PATH)
			--
		local
			converter: EL_PYXIS_TO_XML_CONVERTER; source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create converter.make (a_file_path, create {FILE_PATH})
			converter.execute
			create source.make (converter.source_encoding.encoding, converter.output_path)
			source.print_first (lio, 50)
			source.close
		end

	eiffel_loop_dir: DIR_PATH
		do
			Result := Dev_environ.Eiffel_loop_dir
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Dev_environ.EL_test_data_dir #+ "pyxis", "*.pyx")
		end

feature {NONE} -- Constants

	Checksum_table: EL_HASH_TABLE [NATURAL, STRING]
		once
			create Result.make_equal (11)
			Result ["build.eant.pyx"] := 2323137809
			Result ["configuration.xsd.pyx"] := 1327672612
			Result ["credits.pyx"] := 2202984112
			Result ["i-ching-resource.pyx"] := 3048240178
			Result ["phrases.pyx"] := 1599193884
			Result ["words.pyx"] := 1143708543
			Result [XSL_example] := 2233023973
		end

	Pyxis_encoding: STRING = "%Tversion = 1.0; encoding = %"ISO-8859-1%""

	XSL_example: STRING = "XML XSL Example.xsl.pyx"

end