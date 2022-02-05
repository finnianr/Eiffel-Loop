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
	date: "2022-02-04 9:57:03 GMT (Friday 4th February 2022)"
	revision: "22"

class
	VTD_XML_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
		redefine
			on_prepare
		end

	EL_CRC_32_TEST_ROUTINES

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
		note
			testing: "covers/{EL_XPATH_NODE_CONTEXT}.do_query",
				"covers/{EL_XPATH_NODE_CONTEXT}.context_list",
				"covers/{EL_XPATH_NODE_CONTEXT}.find_node",
				"covers/{EL_XPATH_NODE_CONTEXT}.real_at_xpath",
				"covers/{EL_XPATH_NODE_CONTEXT}.string_at_xpath",
				"covers/{EL_XPATH_NODE_CONTEXT}.integer_at_xpath"
		do
			create root_node.make_from_file (EL_test_data_dir + "vtd-xml/bioinfo.xml")
			assert ("encoding is latin-1", root_node.encoding_name ~ "ISO-8859-1")
			across bioinfo_results_1 as xpath loop
				assert_same_string_8_list (xpath.key, xpath.item, bioinfo_query_1 (xpath.key))
			end
			across bioinfo_results_2 as xpath loop
				assert_same_string_8_list (xpath.key, xpath.item, bioinfo_query_2 (xpath.key))
			end
			across bioinfo_results_3 as xpath loop
				assert_same_string_8_list (xpath.key, xpath.item, bioinfo_query_3 (xpath.key))
			end
			across bioinfo_results_4 as xpath loop
				assert ("same count for " + xpath.key, xpath.item = bioinfo_query_4 (xpath.key))
			end
			across bioinfo_results_5 as xpath loop
				assert_same_string_8_list (xpath.key, xpath.item, bioinfo_query_5 (xpath.key))
			end
		end

	test_cd_catalog_xpath_query
		local
			name: STRING
		do
			create root_node.make_from_file ("vtd-xml/CD-catalog.xml")

			assert ("encoding is UTF-8", root_node.encoding_name ~ "UTF-8")
			across cd_catalog_results as xpath loop
				assert_same_string_list (xpath.key, xpath.item, cd_catalog_query (xpath.key))
			end
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

			assert ("encoding is latin-1", root_node.encoding_name ~ "ISO-8859-1")

			across svg_query_results as xpath loop
				assert ("same result for " + xpath.key, xpath.item ~ svg_query (xpath.key).to_array)
			end

			assert ("same result", svg_sum_query ("//svg/g/line/@x1") = 4522)
			assert ("same result", svg_sum_query ("//svg/g/line/@y1") = 13134)
		end

feature {NONE} -- CD-catalog.xml

	cd_catalog_query (criteria: STRING): EL_ZSTRING_LIST
		local
			xpath: STRING; template: ZSTRING; md5: like Md5_128
		do
			create Result.make (50)
			template := once "/CATALOG/CD[%S]"
			xpath := template #$ [criteria]

			md5 := Md5_128

			across root_node.context_list (xpath) as cd loop
				Result.extend (Template_string_value #$ ["ALBUM", cd.node.string_at_xpath ("TITLE")])
				Result.extend (Template_string_value #$ ["ARTIST", cd.node.string_at_xpath ("ARTIST")])
				Result.extend (Template_string_value #$ ["PRICE", cd.node.string_at_xpath ("PRICE")])
				md5.reset
				across cd.node.context_list ("CONTENTS/TRACK") as track loop
					md5.sink_string (track.node.string_value)
				end
				Result.extend (Template_string_value #$ ["TRACK DIGEST", md5.digest_base_64])
			end
		end

feature {NONE} -- aircraft_power_price.svg

	svg_query (xpath: STRING): ARRAYED_LIST [INTEGER]
		-- distance double coords
		local
			p1, p2: SVG_POINT
		do
			create Result.make (20)
			across root_node.context_list (xpath) as line loop
				create p1.make (line.node.attributes, 1)
				create p2.make (line.node.attributes, 2)
				Result.extend (p1.distance (p2).rounded)
			end
		end

	svg_sum_query (xpath: STRING): INTEGER
			--
		local
			sum: ZSTRING
		do
			sum := "sum (%S)"
			Result := root_node.double_at_xpath (sum #$ [xpath]).rounded
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

			if attached root_node.processing_instruction ("call") as pi_call then
				assert ("expected instruction", pi_call ~ instruction)
			else
				assert ("instruction found", False)
			end
		end

	assert_same_string_8_list (xpath, expected: STRING; actual: EL_STRING_8_LIST)
		local
			expected_lines: EL_STRING_8_LIST
		do
			create expected_lines.make_with_lines (expected)
			assert ("same lines for " + xpath, expected_lines ~ actual)
		end

	assert_same_string_list (xpath: STRING; expected: ZSTRING; actual: EL_ZSTRING_LIST)
		local
			expected_lines: EL_ZSTRING_LIST
		do
			create expected_lines.make_with_lines (expected)
			assert ("same lines for " + xpath, expected_lines ~ actual)
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

	cd_catalog_results: HASH_TABLE [ZSTRING, STRING]
		do
			create Result.make (2)
			Result ["count (CONTENTS/TRACK[contains (lower-case (text()),'blues')]) > 0"] := {STRING_32} "[
				ALBUM: "Still got the blues"
				ARTIST: "Gary More"
				PRICE: "€10.20"
				TRACK DIGEST: "jV2z+F82vcYTRFYx3ykb9A=="
				ALBUM: "Hide your heart"
				ARTIST: "Bonnie Tyler"
				PRICE: "€9.90"
				TRACK DIGEST: "cfLSfV7bzozXrE7dfwVCRg=="
			]"
			Result ["ARTIST [text() = 'Bob Dylan']"] := {STRING_32} "[
				ALBUM: "Empire Burlesque"
				ARTIST: "Bob Dylan"
				PRICE: "€10.90"
				TRACK DIGEST: "kM+gGMDNqjhFjs+jpFGL6g=="
  			]"
			Result ["number (substring (PRICE, 2)) < 10"] := {STRING_32} "[
				ALBUM: "Michael Raucheisen Vol. 12"
				ARTIST: "Michael Raucheisen"
				PRICE: "€7.98"
				TRACK DIGEST: "mkavx41kNphVG29xjEE30g=="
				ALBUM: "Hide your heart"
				ARTIST: "Bonnie Tyler"
				PRICE: "€9.90"
				TRACK DIGEST: "cfLSfV7bzozXrE7dfwVCRg=="
				ALBUM: "Greatest Hits"
				ARTIST: "Dolly Parton"
				PRICE: "€9.90"
				TRACK DIGEST: "d9llgJuZn6O7D2adU5lblA=="
			]"
			Result ["number (substring (PRICE, 2)) > 10"] := {STRING_32} "[
				ALBUM: "Empire Burlesque"
				ARTIST: "Bob Dylan"
				PRICE: "€10.90"
				TRACK DIGEST: "kM+gGMDNqjhFjs+jpFGL6g=="
				ALBUM: "Still got the blues"
				ARTIST: "Gary More"
				PRICE: "€10.20"
				TRACK DIGEST: "jV2z+F82vcYTRFYx3ykb9A=="
			]"
		end

	svg_query_results: HASH_TABLE [ARRAY [INTEGER], STRING]
		local
			xpath: STRING
		do
			create Result.make (2)
			xpath := "//svg/g[starts-with (@style, 'stroke:blue')]/line"
			Result [xpath] := << 6, 4, 6, 4, 6, 4 >>

			xpath := "//svg/g[starts-with (@style, 'stroke:black')]/line"
			Result [xpath] := << 100, 100, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 >>
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