note
	description: "[
		Test classes from library `vtd-xml.ecf'
		
		* ${EL_XPATH_NODE_CONTEXT}
		* ${EL_XML_DOC_CONTEXT}
		* ${EL_XPATH_NODE_CONTEXT_LIST}
	]"
	notes: "[
		Test sets conforming to ${EL_CRC_32_TESTABLE} (like this one) can only be run
		from a sub-application conforming to ${EL_CRC_32_AUTOTEST_APPLICATION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-25 7:14:20 GMT (Monday 25th September 2023)"
	revision: "35"

class
	VTD_XML_TEST_SET

inherit
	EL_DIRECTORY_CONTEXT_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_OS

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["bioinfo_xpath_query",				agent test_bioinfo_xpath_query],
				["cd_catalog_xpath_query",			agent test_cd_catalog_xpath_query],
				["query_processing_instruction",	agent test_query_processing_instruction],
				["root_attribute_selection",		agent test_root_attribute_selection],
				["svg_xpath_query",					agent test_svg_xpath_query]
			>>)
		end

feature -- Tests

	test_bioinfo_xpath_query
		-- VTD_XML_TEST_SET.test_bioinfo_xpath_query
		note
			testing: "covers/{EL_XPATH_NODE_CONTEXT}.do_query",
				"covers/{EL_XPATH_NODE_CONTEXT}.context_list",
				"covers/{EL_XPATH_NODE_CONTEXT}.find_node",
				"covers/{EL_XPATH_NODE_CONTEXT}.query"
		local
			xpath: STRING
		do
			if attached new_xdoc ("vtd-xml/bioinfo.xml") as xdoc then
				assert ("encoding is latin-1", xdoc.encoding_name ~ "ISO-8859-1")

				assert_same_query_results (xdoc, bioinfo_results_1, agent bioinfo_query_1)
				assert_same_query_results (xdoc, bioinfo_results_2, agent bioinfo_query_2)
				assert_same_query_results (xdoc, bioinfo_results_3, agent bioinfo_query_3)
				assert_same_query_results (xdoc, bioinfo_results_4, agent bioinfo_query_4)

				across bioinfo_result_counts as table loop
					xpath := table.key
					assert ("same count for " + xpath, table.item = xdoc.context_list (xpath).count)
				end
			end
		end

	test_cd_catalog_xpath_query
		local
			name, xpath: STRING
		do
			if attached new_xdoc ("vtd-xml/CD-catalog.xml") as xdoc then
				assert ("encoding is UTF-8", xdoc.encoding_name ~ "UTF-8")
				across cd_catalog_results as table loop
					xpath := table.key
					assert_same_string_list (xpath, table.item, cd_catalog_query (xdoc, xpath))
				end
			end
		end

	test_query_processing_instruction
		do
			assert_processing_instruction ("vtd-xml/request-matrix-average.xml", "average")
			assert_processing_instruction ("vtd-xml/request-matrix-sum.xml", "sum")
		end

	test_root_attribute_selection
		local
			en, lang_xpath: STRING; en_32: STRING_32; en_z: ZSTRING
		do
			en := "en"; en_32 := en; en_z := en_32
			if attached new_xdoc ("XML/creatable/download-page.xhtml") as xdoc then
				lang_xpath := "/html/@lang"
			-- Testing auto-convert
				assert ("lang = en", en.is_equal (xdoc.query (lang_xpath)))
				assert ("lang = en_32", en_32.is_equal (xdoc.query (lang_xpath)))
				assert ("lang = en_z", en_z.is_equal (xdoc.query (lang_xpath)))
			end
		end

	test_svg_xpath_query
		local
			name, xpath: STRING
		do
			if attached new_xdoc ("vtd-xml/aircraft_power_price.svg") as xdoc then
				assert ("encoding is latin-1", xdoc.encoding_name ~ "ISO-8859-1")

				across svg_query_results as table loop
					xpath := table.key
					assert ("same result for " + xpath, table.item ~ svg_query (xdoc, xpath).to_array)
				end

				assert ("same result", svg_sum_query (xdoc, "//svg/g/line/@x1") = 4522)
				assert ("same result", svg_sum_query (xdoc, "//svg/g/line/@y1") = 13134)
			end
		end

feature {NONE} -- CD-catalog.xml

	cd_catalog_query (xdoc: EL_XML_DOC_CONTEXT; criteria: STRING): EL_ZSTRING_LIST
		local
			xpath: STRING; template: ZSTRING; md5: like Md5_128
		do
			create Result.make (50)
			template := once "/CATALOG/CD[%S]"
			xpath := template #$ [criteria]

			md5 := Md5_128

			across xdoc.context_list (xpath) as cd loop
				Result.extend (Template_string_value #$ ["ALBUM", cd.node.query ("TITLE").as_string])
				Result.extend (Template_string_value #$ ["ARTIST", cd.node.query ("ARTIST").as_string])
				Result.extend (Template_string_value #$ ["PRICE", cd.node.query ("PRICE").as_string])
				md5.reset
				across cd.node.context_list ("CONTENTS/TRACK") as track loop
					md5.sink_string (track.node.as_full_string)
				end
				Result.extend (Template_string_value #$ ["TRACK DIGEST", md5.digest_base_64])
			end
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

feature {NONE} -- aircraft_power_price.svg

	svg_query (xdoc: EL_XML_DOC_CONTEXT; xpath: STRING): ARRAYED_LIST [INTEGER]
		-- distance double coords
		local
			p1, p2: SVG_POINT
		do
			create Result.make (20)
			across xdoc.context_list (xpath) as line loop
				create p1.make (line.node, 1)
				create p2.make (line.node, 2)
				Result.extend (p1.distance (p2).rounded)
			end
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

	svg_sum_query (xdoc: EL_XML_DOC_CONTEXT; xpath: STRING): INTEGER
			--
		local
			sum: ZSTRING
		do
			sum := "sum (%S)"
			Result := xdoc.query (sum #$ [xpath]).as_double.rounded
		end

feature {NONE} -- bioinfo.xml

	bioinfo_query_1 (xdoc: EL_XML_DOC_CONTEXT; xpath: STRING): EL_STRING_8_LIST
		-- Demonstrates nested queries
		local
			value: STRING
		do
			create Result.make (20)
			across xdoc.context_list (xpath) as context loop
				value := context.node
				Result.extend (Template_string_value #$ [context.node.name, value])
				across context.node.context_list ("following-sibling::value") as following loop
					value := following.node
					Result.extend (Template_bioninfo_query_type #$ [following.node ["type"].as_string_8, value])
				end
			end
		end

	bioinfo_query_2 (xdoc: EL_XML_DOC_CONTEXT; xpath: STRING): EL_STRING_8_LIST
		-- list all url values
		local
			value: ZSTRING
		do
			create Result.make (20)
			across xdoc.context_list (xpath) as label loop
				Result.extend (label.node)
			end
		end

	bioinfo_query_3 (xdoc: EL_XML_DOC_CONTEXT; xpath: STRING): EL_STRING_8_LIST
		-- list all integer values
		local
			result_lines: EL_STRING_8_LIST; id: STRING
		do
			create Result.make (20)
			across xdoc.context_list (xpath) as value loop
				id := value.node.query ("parent::node()/id")
				Result.extend (Template_integer_value #$ [id, value.node.as_integer])
			end
		end

	bioinfo_query_4 (xdoc: EL_XML_DOC_CONTEXT; xpath: STRING): EL_STRING_8_LIST
		-- element count
		local
			id: STRING
		do
			create Result.make (2)
			Result.extend (xdoc.query (xpath))
		end

	bioinfo_result_counts: HASH_TABLE [INTEGER, STRING]
		do
			create Result.make (4)
			Result ["//*"] := 756
			Result ["//package"] := 1
			Result ["//command"] := 6
			Result ["//value[@type='title']"] := 13
		end

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

	bioinfo_results_4: HASH_TABLE [STRING, STRING]
		local
			xpath: STRING
		do
			create Result.make (2)
			xpath := "//value[@type='url' and starts-with (text(), 'http://') and contains (text(), 'strasbg.fr')]/text()"
			Result [xpath] := "http://www-igbmc.u-strasbg.fr/BioInfo/ClustalW/"

			xpath := "//value[@type='url' and starts-with (text(), 'http://') and contains (text(), 'indiana.edu')]/text()"
			Result [xpath] := "http://iubio.bio.indiana.edu/grid/runner/"
		end

feature {NONE} -- Implementation

	assert_processing_instruction (xml_path, instruction: STRING)
			--
		do
			if attached new_xdoc (xml_path) as xdoc then
				assert ("Encoding latin-1", xdoc.encoding_name ~ "ISO-8859-1")

				if attached xdoc.processing_instruction ("call") as pi_call then
					assert ("expected instruction", pi_call ~ instruction)
				else
					failed ("instruction found")
				end
			end
		end

	assert_same_query_results (
		xdoc: EL_XML_DOC_CONTEXT; result_table: HASH_TABLE [STRING, STRING]
		query: FUNCTION [EL_XML_DOC_CONTEXT, STRING, EL_STRING_8_LIST]
	)
		local
			xpath: STRING
		do
			across result_table as table loop
				xpath := table.key
				assert_same_string_8_list (xpath, table.item, query (xdoc, xpath))
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

	new_xdoc (path: STRING): EL_XML_DOC_CONTEXT
		do
			create Result.make_from_file (path)
		end

	working_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir
		end

feature {NONE} -- Constants

	Template_bioninfo_query_type: ZSTRING
		once
			Result := "[
				@type: "#" #
			]"
		end
	Template_integer_value: ZSTRING
		once
			Result := "[
				#: #
			]"
		end

	Template_string_value: ZSTRING
		once
			Result := "[
				#: "#"
			]"
		end

end