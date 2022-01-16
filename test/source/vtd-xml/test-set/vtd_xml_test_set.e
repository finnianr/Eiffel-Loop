note
	description: "[
		Test classes from library `vtd-xml.ecf'
		
		* [$source EL_XPATH_NODE_CONTEXT]
		* [$source EL_XPATH_ROOT_NODE_CONTEXT]
		* [$source EL_XPATH_NODE_CONTEXT_LIST]
	]"
	notes: "[
		Test sets conforming to [$source EL_EQA_REGRESSION_TEST_SET] (like this one) can only be run
		from a sub-application conforming to [$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-16 19:14:21 GMT (Sunday 16th January 2022)"
	revision: "18"

class
	VTD_XML_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
		redefine
			on_prepare
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_MODULE_OS

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor {EIFFEL_LOOP_TEST_SET}
			create root_node
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("bioinfo_xpath_query", agent test_bioinfo_xpath_query)
			eval.call ("cd_catalog_xpath_query", agent test_cd_catalog_xpath_query)
			eval.call ("query_processing_instruction", agent test_query_processing_instruction)
			eval.call ("svg_xpath_query", agent test_svg_xpath_query)
		end

feature -- Tests

	test_bioinfo_xpath_query
		do
			create root_node.make_from_file (EL_test_data_dir + "vtd-xml/bioinfo.xml")
			assert ("encoding latin-1", root_node.encoding_name ~ "ISO-8859-1")
			across bioinfo_results_1 as xpath loop
				assert_same_result (xpath.key, xpath.item, bioinfo_query_1 (xpath.key))
			end
			across bioinfo_results_2 as xpath loop
				assert_same_result (xpath.key, xpath.item, bioinfo_query_2 (xpath.key))
			end
			across bioinfo_results_3 as xpath loop
				assert_same_result (xpath.key, xpath.item, bioinfo_query_3 (xpath.key))
			end
			across bioinfo_results_4 as xpath loop
				assert ("same count for " + xpath.key, xpath.item = bioinfo_query_4 (xpath.key))
			end
			across bioinfo_results_5 as xpath loop
				assert_same_result (xpath.key, xpath.item, bioinfo_query_5 (xpath.key))
			end
		end

	test_cd_catalog_xpath_query
		local
			name: STRING
		do
			create root_node.make_from_file ("vtd-xml/CD-catalog.xml")

			do_test ("cd_catalog_encoding", 3672545284, agent encoding, [])

			name := "cd_catalog_query"
			do_test (
				name, 1668501835,
				agent cd_catalog_query, ["count (CONTENTS/TRACK[contains (lower-case (text()),'blues')]) > 0"]
			)
			do_test (name, 1009490940, agent cd_catalog_query, ["ARTIST [text() = 'Bob Dylan']"])
			do_test (name, 3219963938, agent cd_catalog_query, ["number (substring (PRICE, 2)) < 10"])
			do_test (name, 3197753, agent cd_catalog_query, ["number (substring (PRICE, 2)) > 10"])
		end

	test_query_processing_instruction
		do
			assert_processing_instruction ("vtd-xml/request-matrix-average.xml", "average")
			assert_processing_instruction ("vtd-xml/request-matrix-sum.xml", "sum")
		end

	test_svg_xpath_query
		local
			name: STRING
		do
			create root_node.make_from_file ("vtd-xml/aircraft_power_price.svg")

			do_test ("svg_encoding", 781775463, agent encoding, [])
			name := "svg_query_1"
			do_test (name, 3303566290, agent svg_query_1, ["//svg/g[starts-with (@style, 'stroke:blue')]/line"])
			name := "svg_query_2"
			do_test (name, 3058580805, agent svg_query_2, ["//svg/g[starts-with (@style, 'stroke:black')]/line"])

			name := "svg_query_3"
			do_test (name, 1226289817, agent svg_query_3, ["sum (//svg/g/line/@x1)"])
			do_test (name, 4097543096, agent svg_query_3, ["sum (//svg/g/line/@y1)"])
		end

feature {NONE} -- CD-catalog.xml

	cd_catalog_query (criteria: STRING)
		local
			xpath: STRING; template: ZSTRING
		do
			template := once "/CATALOG/CD[%S]"
			xpath := template #$ [criteria]

			across root_node.context_list (xpath) as cd loop
				log.put_string_field ("ALBUM", cd.node.string_at_xpath ("TITLE"))
				log.put_new_line
				log.put_string_field ("ARTIST", cd.node.string_at_xpath ("ARTIST"))
				log.put_new_line
				log.put_string_field ("PRICE", cd.node.string_at_xpath ("PRICE"))
				log.put_new_line
				across cd.node.context_list ("CONTENTS/TRACK") as track loop
					log.put_string ("    " + track.cursor_index.out + ". ")
					log.put_line (track.node.string_value)
				end
				log.put_new_line
			end
		end

feature {NONE} -- aircraft_power_price.svg

	svg_query_1 (xpath: STRING)
			-- distance double coords
		local
			p1, p2: SVG_POINT
		do
			across root_node.context_list (xpath) as line loop
				create p1.make (line.node.attributes, 1)
				create p2.make (line.node.attributes, 2)
				log.put_double_field ("line length", p1.distance (p2))
				log.put_new_line
			end
		end

	svg_query_2 (xpath: STRING)
			-- distance integer coords
		local
			line_node_list: EL_XPATH_NODE_CONTEXT_LIST
			p1, p2: SVG_INTEGER_POINT
		do
			across root_node.context_list (xpath) as line loop
				create p1.make (line.node.attributes, 1)
				create p2.make (line.node.attributes, 2)
				log.put_double_field ("line length", p1.distance (p2))
				log.put_new_line
			end
		end

	svg_query_3 (xpath: STRING)
			--
		do
			log.put_double_field (xpath, root_node.double_at_xpath (xpath))
			log.put_new_line
		end

feature {NONE} -- bioinfo.xml

	bioinfo_query_1 (xpath: STRING): EL_STRING_8_LIST
		-- Demonstrates nested queries
		local
			value: STRING
		do
			create Result.make (20)
			across root_node.context_list (xpath) as context loop
				value := context.node.normalized_string_value
				Result.extend (Template_string_value #$ [context.node.name, value])
				across context.node.context_list ("following-sibling::value") as following loop
					value := following.node.normalized_string_value
					Result.extend (Template_bioninfo_query_type #$ [following.node.attributes ["type"], value])
				end
			end
		end

	bioinfo_query_2 (xpath: STRING): EL_STRING_8_LIST
		-- list all url values
		local
			value: ZSTRING
		do
			create Result.make (20)
			across root_node.context_list (xpath) as label loop
				Result.extend (label.node.normalized_string_value)
			end
		end

	bioinfo_query_3 (xpath: STRING): EL_STRING_8_LIST
		-- list all integer values
		local
			result_lines: EL_STRING_8_LIST; id: STRING
		do
			create Result.make (20)
			across root_node.context_list (xpath) as value loop
				id := value.node.string_at_xpath ("parent::node()/id")
				Result.extend (Template_integer_value #$ [id, value.node.integer_value])
			end
		end

	bioinfo_query_4 (xpath: STRING): INTEGER
		-- element count
		do
			Result := root_node.context_list (xpath).count
		end

	bioinfo_query_5 (xpath: STRING): EL_STRING_8_LIST
		-- element count
		local
			id: STRING
		do
			create Result.make (2)
			Result.extend (root_node.string_at_xpath (xpath))
		end

feature {NONE} -- Implementation

	assert_processing_instruction (file_path: FILE_PATH; instruction: STRING)
			--
		do
			create root_node.make_from_file (file_path)
			assert ("Encoding latin-1", root_node.encoding_name ~ "ISO-8859-1")
			root_node.find_instruction ("call")
			assert ("expected instruction", root_node.instruction_found and then root_node.found_instruction ~ instruction)
		end

	assert_same_result (xpath, expected_result: STRING; result_lines: EL_STRING_8_LIST)
		local
			expected_result_lines: EL_STRING_8_LIST
		do
			create expected_result_lines.make_with_lines (expected_result)
			assert ("expected results for " + xpath, expected_result_lines ~ result_lines)
		end

	encoding
		do
			log.put_string_field ("Encoding", root_node.encoding_name)
			log.put_new_line
		end

feature {NONE} -- Internal attributes

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

feature {NONE} -- Query results

	bioinfo_results_1: HASH_TABLE [STRING, STRING]
		do
			create Result.make (2)
			Result ["//par/label[count (following-sibling::value) = 2]"] := "[
				label: "Gap penalty"
				@type: "intRange" 3,1,500,1
				@type: "intRange" 5,1,50,1
				label: "Wordsize (ktuple)"
				@type: "intRange" 1,1,2,1
				@type: "intRange" 2,1,4,1
				label: "Number of best diagonals"
				@type: "intRange" 5,1,50,1
				@type: "intRange" 4,1,50,1
				label: "Window size"
				@type: "intRange" 5,1,50,1
				@type: "intRange" 4,1,50,1
				label: "Window Gap extension"
				@type: "floatRange" 0.1,0,10,0.1
				@type: "floatRange" 5.0,0,10,0.1
				label: "Gap extension penalty"
				@type: "floatRange" 0.05,0,10,0.1
				@type: "floatRange" 5.0,0,10,0.1
			]"
			Result ["//par/label[count (following-sibling::value [@type = 'intRange']) = 2]"] := "[
				label: "Gap penalty"
				@type: "intRange" 3,1,500,1
				@type: "intRange" 5,1,50,1
				label: "Wordsize (ktuple)"
				@type: "intRange" 1,1,2,1
				@type: "intRange" 2,1,4,1
				label: "Number of best diagonals"
				@type: "intRange" 5,1,50,1
				@type: "intRange" 4,1,50,1
				label: "Window size"
				@type: "intRange" 5,1,50,1
				@type: "intRange" 4,1,50,1
			]"
		end

	bioinfo_results_2: HASH_TABLE [STRING, STRING]
		do
			create Result.make (3)
			Result ["//label[contains (text(), 'branches')]"] := "[
				Global1: the number of branches to cross in rearrangements of the completed tree
				Global2: the number of branches to cross in testing rearrangements
			]"
			Result ["//value[@type='url' and contains (text(), 'http://')]"] := "[
				http://iubio.bio.indiana.edu/grid/runner/
				http://iubio.bio.indiana.edu/grid/runner/docs/bix.dtd
				http://www-igbmc.u-strasbg.fr/BioInfo/ClustalW/
				http://geta.life.uiuc.edu/~gary/programs/fastDNAml.html
			]"
			Result ["//value[@type='url']/text()"] := "[
				http://iubio.bio.indiana.edu/grid/runner/
				http://iubio.bio.indiana.edu/grid/runner/docs/bix.dtd
				http://www-igbmc.u-strasbg.fr/BioInfo/ClustalW/
				http://geta.life.uiuc.edu/~gary/programs/fastDNAml.html
				file:${docpath}tacg3.main.html
			]"
		end

	bioinfo_results_3: HASH_TABLE [STRING, STRING]
		do
			create Result.make (2)
			Result ["//value[@type='integer']"] := "[
				BOOTVAL: 1000
				MIN_OVERLAP: 20
				bootseed: 987
				catnum: 1
				jumbleseed: 987
				outval: 1
			]"
			Result ["//value[@type='integer' and number (text ()) > 100]"] := "[
				BOOTVAL: 1000
				bootseed: 987
				jumbleseed: 987
 			]"
		end

	bioinfo_results_4: HASH_TABLE [INTEGER, STRING]
		do
			create Result.make (4)
			Result ["//*"] := 756
			Result ["//package"] := 1
			Result ["//command"] := 6
			Result ["//value[@type='title']"] := 13
		end

	bioinfo_results_5: HASH_TABLE [STRING, STRING]
		local
			xpath: STRING
		do
			create Result.make (2)
			xpath := "//value[@type='url' and starts-with (text(), 'http://') and contains (text(), 'strasbg.fr')]/text()"
			Result [xpath] := "http://www-igbmc.u-strasbg.fr/BioInfo/ClustalW/"

			xpath := "//value[@type='url' and starts-with (text(), 'http://') and contains (text(), 'indiana.edu')]/text()"
			Result [xpath] := "http://iubio.bio.indiana.edu/grid/runner/"
		end

feature {NONE} -- Constants

	Template_string_value: ZSTRING
		once
			Result := "[
				#: "#"
			]"
		end

	Template_integer_value: ZSTRING
		once
			Result := "[
				#: #
			]"
		end

	Template_bioninfo_query_type: ZSTRING
		once
			Result := "[
				@type: "#" #
			]"
		end
end