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
	date: "2020-02-14 13:42:10 GMT (Friday 14th February 2020)"
	revision: "16"

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
			eval.call ("query_processing_instruction",	agent test_query_processing_instruction)
			eval.call ("cd_catalog_xpath_query",			agent test_cd_catalog_xpath_query)
			eval.call ("svg_xpath_query",						agent test_svg_xpath_query)
			eval.call ("bioinfo_xpath_query_1",				agent test_bioinfo_xpath_query)
		end

feature -- Tests

	test_bioinfo_xpath_query
		local
			name: STRING
		do
			create root_node.make_from_file (EL_test_data_dir + "vtd-xml/bioinfo.xml")
			do_test ("bioinfo_encoding", 4159057012, agent encoding, [])
			name := "bioinfo_query_1"
			do_test (name, 2720094262, agent bioinfo_query_1, ["//par/label[count (following-sibling::value) = 2]"])
			do_test (
				name, 2095404682,
				agent bioinfo_query_1, ["//par/label[count (following-sibling::value [@type = 'intRange']) = 2]"]
			)

			name := "bioinfo_query_2"
			do_test (name, 817474564, agent bioinfo_query_2, ["//label[contains (text(), 'branches')]"])
			do_test (name, 3115874359, agent bioinfo_query_2, ["//value[@type='url' and contains (text(), 'http://')]"])
			do_test (name, 3290729442, agent bioinfo_query_2, ["//value[@type='url']/text()"])

			name := "bioinfo_query_3"
			do_test (name, 1100944812, agent bioinfo_query_3, ["//value[@type='integer']"])
			do_test (name, 113201598, agent bioinfo_query_3, ["//value[@type='integer' and number (text ()) > 100]"])

			name := "bioinfo_query_4"
			do_test (name, 78172724, agent bioinfo_query_4, ["Element count", "//*"])
			do_test (name, 3787589092, agent bioinfo_query_4, ["Package count", "//package"])
			do_test (name, 11659765, agent bioinfo_query_4, ["Command count", "//command"])
			do_test (name, 2610705622, agent bioinfo_query_4, ["Title count", "//value[@type='title']"])
			name := "bioinfo_query_5"
			do_test (
				name, 1831613446,
				agent bioinfo_query_5, [
					"URL (strasbg.fr)",
					"//value[@type='url' and starts-with (text(), 'http://') and contains (text(), 'strasbg.fr')]/text()"
				]
			)
			do_test (
				name, 4187769338,
				agent bioinfo_query_5, [
					"URL (indiana.edu)",
					"//value[@type='url' and starts-with (text(), 'http://') and contains (text(), 'indiana.edu')]/text()"
				]
			)
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
		local
			file_path: EL_FILE_PATH
		do
			file_path := "vtd-xml/request-matrix-average.xml"
			do_test ("query_processing_instruction", 1660076206, agent query_processing_instruction, [file_path])

			file_path := "vtd-xml/request-matrix-sum.xml"
			do_test ("query_processing_instruction", 1798316178, agent query_processing_instruction, [file_path])
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

	bioinfo_query_1 (xpath: STRING)
			-- Demonstrates nested queries
		local
			par_value_list, label_node_list: EL_XPATH_NODE_CONTEXT_LIST
		do
			label_node_list := root_node.context_list (xpath)
			from label_node_list.start until label_node_list.after loop
				log.put_string_field (
					label_node_list.context.name, label_node_list.context.normalized_string_value
				)
				log.put_new_line
				par_value_list := label_node_list.context.context_list ("following-sibling::value")
				from par_value_list.start until par_value_list.after loop
					log.put_string_field ("@type", par_value_list.context.attributes ["type"])
					log.put_string (" ")
					log.put_string (par_value_list.context.normalized_string_value)
					log.put_new_line
					par_value_list.forth
				end
				log.put_new_line
				label_node_list.forth
			end
		end

	bioinfo_query_2 (xpath: STRING)
			-- list all url values
		do
			across root_node.context_list (xpath) as label loop
				log.put_line (label.node.normalized_string_value)
			end
		end

	bioinfo_query_3 (xpath: STRING)
			-- list all integer values
		local
			id: STRING
		do
			across root_node.context_list (xpath) as value loop
				id := value.node.string_at_xpath ("parent::node()/id")
				log.put_integer_field (id, value.node.integer_value)
				log.put_new_line
			end
		end

	bioinfo_query_4 (label, xpath: STRING)
			-- element count
		do
			log.put_integer_field (label, root_node.context_list (xpath).count)
			log.put_new_line
		end

	bioinfo_query_5 (label, xpath: STRING)
			-- element count
		do
			log.put_string_field (label, root_node.string_at_xpath (xpath))
			log.put_new_line
		end

feature {NONE} -- Implementation

	encoding
		do
			log.put_string_field ("Encoding", root_node.encoding_name)
			log.put_new_line
		end

	query_processing_instruction (file_path: EL_FILE_PATH)
			--
		do
			create root_node.make_from_file (file_path)
			log.put_string_field ("Encoding", root_node.encoding_name)
			log.put_new_line

			root_node.find_instruction ("call")
			if root_node.instruction_found then
				log.put_string_field ("call", root_node.found_instruction)
			else
				log.put_string_field ("No such instruction", "call")
			end
			log.put_new_line
		end

feature {NONE} -- Internal attributes

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

end
