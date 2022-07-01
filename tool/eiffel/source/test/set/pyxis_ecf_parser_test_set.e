note
	description: "Test class [$source PYXIS_ECF_PARSER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-01 14:55:33 GMT (Friday 1st July 2022)"
	revision: "20"

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
			eval.call ("settings_transformation", agent test_settings_transformation)
		end

feature -- Tests

	test_conversion_to_pecf
			--
		local
			ecf_xdoc: EL_XPATH_ROOT_NODE_CONTEXT; file_rule_count, windows_count: INTEGER
			schema_location, platform_value, exclude_value: STRING
		do
			ecf_xdoc := new_ecf_xdoc (library_pecf_path)
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

	test_settings_transformation
		local
			ecf_xdoc: EL_XPATH_ROOT_NODE_CONTEXT; file_rule_count, windows_count: INTEGER
			schema_location, platform_value, exclude_value, name: STRING
		do
			ecf_xdoc := new_ecf_xdoc (project_pecf_path)
			across
				<< "address_expression", "array_optimization", "dynamic_runtime", "line_generation" >> as list
			loop
				assert ("false", ecf_xdoc.query (Setting_xpath #$ [list.item]).as_string_8 ~ "false")
			end
			across ("check_vape, dead_code_removal, inlining, console_application").split (',') as list loop
				name := list.item; name.left_adjust
				assert ("true", ecf_xdoc.query (Setting_xpath #$ [name]).as_string_8 ~ "true")
			end
		end

feature {NONE} -- Implementation

	library_pecf_path: FILE_PATH
		do
			Result := Eiffel_loop_dir + "library/eiffel2java.pecf"
		end

	project_pecf_path: FILE_PATH
		do
			Result := "eiffel.pecf"
		end

	unix_exclude: STRING
		do
			Result := "file_rule [condition/platform/@value = 'unix']/exclude"
		end

	new_ecf_xdoc (pecf_path: FILE_PATH): EL_XPATH_ROOT_NODE_CONTEXT
		local
			converter: PYXIS_ECF_CONVERTER;
			schema_location, platform_value, exclude_value: STRING; file_rule_count, windows_count: INTEGER
		do
			create converter.make (pecf_path, Work_area_dir + (pecf_path.base_sans_extension + ".xml"))
			converter.execute
			create Result.make_from_file (converter.output_path)
		end

feature {NONE} -- Constants

	Valid_platforms: EL_STRING_8_LIST
		once
			Result := "unix, windows"
		end

	Setting_xpath: ZSTRING
		once
			Result := "/system/target/setting[@name='%S']/@value"
		end

end