note
	description: "Test VTD XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 13:33:10 GMT (Friday 31st January 2020)"
	revision: "13"

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

feature {NONE} -- Initialization

	on_prepare
		do
			Precursor {EIFFEL_LOOP_TEST_SET}
			create root_node
		end

feature -- Tests

	test_bioinfo_xpath_query
		local
			name: STRING
		do
			create root_node.make_from_file (EL_test_data_dir + "vtd-xml/bioinfo.xml")
			do_test (
				"bioinfo_encoding", 4159057012, agent bioinfo_encoding, []
			)
			name := "bioinfo_query_1"
			do_test (
				name, 2720094262, agent bioinfo_query_1, ["//par/label[count (following-sibling::value) = 2]"]
			)
			do_test (
				name, 2095404682,
				agent bioinfo_query_1, ["//par/label[count (following-sibling::value [@type = 'intRange']) = 2]"]
			)

			name := "bioinfo_query_2"
			do_test (
				name, 817474564, agent bioinfo_query_2, ["//label[contains (text(), 'branches')]"]
			)
			do_test (
				name, 3115874359,
				agent bioinfo_query_2, ["//value[@type='url' and contains (text(), 'http://')]"]
			)
			do_test (
				name, 3290729442, agent bioinfo_query_2, ["//value[@type='url']/text()"]
			)

			name := "bioinfo_query_3"
			do_test (
				name, 1100944812, agent bioinfo_query_3, ["//value[@type='integer']"]
			)
			do_test (
				name, 113201598, agent bioinfo_query_3, ["//value[@type='integer' and number (text ()) > 100]"]
			)

			name := "bioinfo_query_4"
			do_test (
				name, 78172724, agent bioinfo_query_4, ["Element count", "//*"]
			)
			do_test (
				name, 3787589092, agent bioinfo_query_4, ["Package count", "//package"]
			)
			do_test (
				name, 11659765, agent bioinfo_query_4, ["Command count", "//command"]
			)
			do_test (
				name, 2610705622, agent bioinfo_query_4, ["Title count", "//value[@type='title']"]
			)

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

feature {NONE} -- Implementation

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

	bioinfo_encoding
		do
			log.put_string_field ("Encoding", root_node.encoding_name)
			log.put_new_line
		end

feature {NONE} -- Internal attributes

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

end
