note
	description: "Test class [$source PYXIS_ECF_PARSER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-28 14:15:40 GMT (Tuesday 28th June 2022)"
	revision: "18"

class
	PYXIS_ECF_PARSER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

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
			schema_location, node_str, platform_value, exclude_value: STRING; file_rule_count, windows_count: INTEGER
		do
			create converter.make (pecf_path, Work_area_dir + (pecf_path.base_sans_extension + ".xml"))
			converter.execute
			create ecf_xdoc.make_from_file (converter.output_path)
			across ecf_xdoc.context_list ("//file_rule") as rule loop
				platform_value := rule.node.query ("condition/platform/@value")
				exclude_value := rule.node.query ("exclude/text()")
				assert ("valid platform", Valid_platforms.has (platform_value))
				assert ("valid unix exclude", platform_value ~ "unix" implies exclude_value ~ "/imp_mswin$")
				assert ("valid windows exclude", platform_value ~ "windows" implies exclude_value ~ "/imp_unix$")
				file_rule_count := file_rule_count + 1
			end
			assert ("file rule count", file_rule_count = 2)

			across ecf_xdoc.context_list ("//library") as library loop
				platform_value := library.node.query ("condition/platform/@value")
				if platform_value ~ "windows" then
					windows_count := windows_count + 1
				end
			end
			assert ("windows platform condition count", windows_count = 1)

			assert ("valid default namespace", ecf_xdoc.namespace_table ["default"].ends_with ("xml/configuration-1-16-0"))
			assert ("valid xsi namespace", ecf_xdoc.namespace_table ["xsi"].ends_with ("XMLSchema-instance"))

			ecf_xdoc.set_namespace_key ("xsi")
			schema_location := ecf_xdoc.query ("@xsi:schemaLocation")
			assert ("valid xsi:schemaLocation", schema_location.ends_with ("configuration-1-16-0.xsd"))
		end

feature {NONE} -- Implementation

	pecf_path: FILE_PATH
		do
			Result := Eiffel_loop_dir + "library/eiffel2java.pecf"
		end

	unix_exclude: STRING
		do
			Result := "file_rule [condition/platform/@value = 'unix']/exclude"
		end

feature {NONE} -- Constants

	Valid_platforms: EL_STRING_8_LIST
		once
			Result := "unix, windows"
		end

end