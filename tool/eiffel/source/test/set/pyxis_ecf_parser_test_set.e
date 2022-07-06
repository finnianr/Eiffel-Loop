note
	description: "Test class [$source PYXIS_ECF_PARSER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 8:33:11 GMT (Wednesday 6th July 2022)"
	revision: "25"

class
	PYXIS_ECF_PARSER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("eiffel2java_pecf", agent test_eiffel2java_pecf)
			eval.call ("graphical_pecf", agent test_graphical_pecf)
			eval.call ("eiffel_pecf", agent test_eiffel_pecf)
		end

feature -- Tests

	test_eiffel2java_pecf
			--
		local
			ecf_xdoc: EL_XPATH_ROOT_NODE_CONTEXT; file_rule_count, windows_count: INTEGER
			schema_location, platform_value, exclude_value: STRING
		do
			ecf_xdoc := new_ecf_xdoc (library_pecf_path)
			assert ("6 libraries", library_count (ecf_xdoc) = 6)
			across ecf_xdoc.context_list ("//file_rule") as rule loop
				platform_value := rule.node.query ("condition/platform/@value")
				exclude_value := rule.node.query ("exclude/text()")
				assert ("valid platform", Valid_platforms.has (platform_value))
				assert ("valid unix exclude", platform_value ~ "unix" implies exclude_value ~ "/imp_mswin$")
				assert ("valid windows exclude", platform_value ~ "windows" implies exclude_value ~ "/imp_unix$")
				file_rule_count := file_rule_count + 1
			end
			assert ("file rule count", file_rule_count = 2)

			across ecf_xdoc.context_list ("//library [condition/platform/@value='windows']") as library loop
				assert ("WEL regedit", library.node.query ("@name").as_string_8 ~ "EL_wel_regedit")
				windows_count := windows_count + 1
			end
			assert ("windows platform condition count", windows_count = 1)
			if attached ecf_xdoc.query ("/system/target/cluster[@name='Java']/@location").as_string_8 as location then
				assert ("Java cluster", location.ends_with ("Java"))
			end

			assert ("valid default namespace", ecf_xdoc.namespace_table ["default"].ends_with ("xml/configuration-1-16-0"))
			assert ("valid xsi namespace", ecf_xdoc.namespace_table ["xsi"].ends_with ("XMLSchema-instance"))

			ecf_xdoc.set_namespace_key ("xsi")
			schema_location := ecf_xdoc.query ("@xsi:schemaLocation")
			assert ("valid xsi:schemaLocation", schema_location.ends_with ("configuration-1-16-0.xsd"))
		end

	test_graphical_pecf
		local
			ecf_xdoc: EL_XPATH_ROOT_NODE_CONTEXT; name, xpath: STRING
			location_steps: EL_PATH_STEPS
		do
			ecf_xdoc := new_ecf_xdoc (graphical_pecf_path)
			assert ("17 libraries", library_count (ecf_xdoc) = 17)
			across ("__unnamed_debug__, wel_gdi_references, win_dispatcher").split (',') as list loop
				name := list.item; name.left_adjust
				assert ("debug false", ecf_xdoc.query (Option_setting_xpath #$ ["debug", name]).as_string_8 ~ "false")
			end
			across ("export_class_missing, vjrv").split (',') as list loop
				name := list.item; name.left_adjust
				assert ("warning false", ecf_xdoc.query (Option_setting_xpath #$ ["warning", name]).as_string_8 ~ "false")
			end
			across <<
				"address_expression", "array_optimization", "dynamic_runtime",
				"exception_trace", "inlining", "line_generation" >> as list
			loop
				assert ("false", ecf_xdoc.query (Setting_xpath #$ [list.item]).as_string_8 ~ "false")
			end
			across ("check_vape, dead_code_removal, console_application").split (',') as list loop
				name := list.item; name.left_adjust
				assert ("true", ecf_xdoc.query (Setting_xpath #$ [name]).as_string_8 ~ "true")
			end
			assert ("true", ecf_xdoc.query (Setting_xpath #$ ["concurrency"]).as_string_8 ~ "thread")

			across Library_table as table loop
				xpath := Library_location_xpath #$ [table.key]
				location_steps := ecf_xdoc.query (xpath).as_file_path
				assert ("is library path", location_steps.item (2).same_string ("library"))
				assert (table.key, location_steps.base.same_string (table.item))
			end
			assert ("is GUI-application.ecf", has_precompile (ecf_xdoc, "GUI-application.ecf"))
		end

	test_eiffel_pecf
		local
			ecf_xdoc: EL_XPATH_ROOT_NODE_CONTEXT; sub_cluster_count: INTEGER
			name, location: STRING
		do
			ecf_xdoc := new_ecf_xdoc (project_pecf_path)
			assert ("21 libraries", library_count (ecf_xdoc) = 21)
			if attached ecf_xdoc.context_list ("//cluster [@recursive='true']") as list then
				assert ("4 recursive", list.count = 4)
			end
			across ecf_xdoc.context_list ("/system/target/cluster [@name='Test_common']") as cluster loop
				across cluster.node.context_list ("cluster") as sub_cluster loop
					name := sub_cluster.node ["name"]
					location := sub_cluster.node ["location"]
					assert ("valid sub cluster", location.ends_with (name) and location.starts_with ("$|"))
					sub_cluster_count := sub_cluster_count + 1
				end
			end
			assert ("2 sub clusters", sub_cluster_count = 2)

			if attached ecf_xdoc.find_node ("/system/target/variable[@name='eapml_limb_type']") as variable then
				assert ("is natural_32", variable ["value"].as_string_8 ~ "natural_32")
			else
				assert ("found variable eapml_limb_type", False)
			end
			if attached ecf_xdoc.find_node ("/system/target/cluster[@name='Test_common']") as cluster then
				assert ("is source/common", cluster ["location"].as_string_8.ends_with ("source/common"))
			else
				assert ("found Test_common cluster", False)
			end
			assert ("is console-application.ecf", has_precompile (ecf_xdoc, "console-application.ecf"))
		end

feature {NONE} -- Implementation

	graphical_pecf_path: FILE_PATH
		do
			Result := Eiffel_loop_dir + "example/graphical/graphical.pecf"
		end

	has_precompile (ecf_xdoc: EL_XPATH_ROOT_NODE_CONTEXT; name: STRING): BOOLEAN
		do
			if attached ecf_xdoc.find_node ("/system/target/precompile[@name='precompile']") as precompile then
				Result := precompile ["location"].as_string_8.ends_with (name)
			end
		end

	library_pecf_path: FILE_PATH
		do
			Result := Eiffel_loop_dir + "library/eiffel2java.pecf"
		end

	library_count (ecf_xdoc: EL_XPATH_ROOT_NODE_CONTEXT): INTEGER
		do
			Result := ecf_xdoc.context_list ("//library").count
		end

	new_ecf_xdoc (pecf_path: FILE_PATH): EL_XPATH_ROOT_NODE_CONTEXT
		local
			converter: PYXIS_ECF_CONVERTER
		do
			create converter.make (pecf_path, Work_area_dir + (pecf_path.base_sans_extension + ".xml"))
			converter.execute
			create Result.make_from_file (converter.output_path)
		end

	project_pecf_path: FILE_PATH
		do
			Result := "eiffel.pecf"
		end

	unix_exclude: STRING
		do
			Result := "file_rule [condition/platform/@value = 'unix']/exclude"
		end

feature {NONE} -- Constants

	Library_location_xpath: ZSTRING
		once
			Result := "/system/target/library[@name='%S']/@location"
		end

	Library_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["EL_app_manage", "app-manage.ecf"],
				["EL_xml_scan", "xml-scan.ecf"],
				["base", "base.ecf"],
				["time", "time.ecf"]
			>>)
		end

	Option_setting_xpath: ZSTRING
		once
			Result := "/system/target/option/%S[@name='%S']/@enabled"
		end

	Setting_xpath: ZSTRING
		once
			Result := "/system/target/setting[@name='%S']/@value"
		end

	Valid_platforms: EL_STRING_8_LIST
		once
			Result := "unix, windows"
		end

end