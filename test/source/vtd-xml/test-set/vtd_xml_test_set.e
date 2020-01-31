note
	description: "Test VTD XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 11:58:34 GMT (Friday 31st January 2020)"
	revision: "12"

class
	VTD_XML_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_LOG

	EL_SHARED_TEST_CRC

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor
			create root_node
		end

feature -- Tests

	test_bioinfo_xpath_query_1
		do
			create root_node.make_from_file (EL_test_data_dir + "vtd-xml/bioinfo.xml")
			do_test (
				agent do_query_bioinfo_1 ("//par/label[count (following-sibling::value) = 2]"), 3597580262
			)
			do_test (
				agent do_query_bioinfo_1 ("//par/label[count (following-sibling::value [@type = 'intRange']) = 2]"), 2895237064
			)
		end

feature {NONE} -- Implementation

	do_query_bioinfo_1 (xpath: STRING)
			-- Demonstrates nested queries
		local
			par_value_list, label_node_list: EL_XPATH_NODE_CONTEXT_LIST
		do
			log.enter_with_args ("do_query_bioinfo_1", [xpath])
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
			log.exit
		end

	do_test (test: PROCEDURE; target: NATURAL)
		local
			actual: NATURAL
		do
			Test_crc.reset; test.apply

			actual := Test_crc.checksum
			if target /= actual then
				log.put_natural_field ("Target checksum", target)
				log.put_natural_field (" Actual checksum", actual)
				log.put_new_line
				assert ("checksums agree", False)
			end
		end

feature {NONE} -- Internal attributes

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

end
