note
	description: "Test class [$source PYXIS_ECF_PARSER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 17:59:12 GMT (Thursday 24th February 2022)"
	revision: "17"

class
	PYXIS_ECF_PARSER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as EL_test_data_dir
		end

	EIFFEL_LOOP_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("conversion_to_pecf", agent test_conversion_to_pecf)
		end

feature -- Tests

	test_conversion_to_pecf
			--
		local
			converter: PYXIS_ECF_CONVERTER; ecf_xdoc: EL_XPATH_ROOT_NODE_CONTEXT
			schema_location: STRING
		do
			create converter.make (file_list.first_path, create {FILE_PATH})
			converter.execute
			create ecf_xdoc.make_from_file (converter.output_path)
			assert ("file rule count", ecf_xdoc.context_list ("//file_rule").count = 16)

			assert ("valid default namespace", ecf_xdoc.namespace_table ["default"].ends_with ("xml/configuration-1-4-0"))
			assert ("valid xsi namespace", ecf_xdoc.namespace_table ["xsi"].ends_with ("XMLSchema-instance"))

			ecf_xdoc.set_namespace_key ("xsi")
			schema_location := ecf_xdoc.query ("@xsi:schemaLocation")
			assert ("valid xsi:schemaLocation", schema_location.ends_with ("configuration-1-4-0.xsd"))
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (EL_test_data_dir #+ "pyxis", "*.pecf")
		end

end