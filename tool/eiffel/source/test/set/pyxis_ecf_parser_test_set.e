note
	description: "Test class [$source PYXIS_ECF_PARSER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-07 16:36:22 GMT (Monday 7th November 2022)"
	revision: "34"

class
	PYXIS_ECF_PARSER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	SHARED_DEV_ENVIRON

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("backwards_compatibility", agent test_backwards_compatibility)
			eval.call ("c_externals_path", agent test_c_externals_path)
			eval.call ("eiffel2java_pecf", agent test_eiffel2java_pecf)
			eval.call ("eiffel_pecf", agent test_eiffel_pecf)
			eval.call ("excluded_value_conditions", agent test_excluded_value_conditions)
			eval.call ("graphical_pecf", agent test_graphical_pecf)
		end

feature -- Tests

	test_backwards_compatibility
		local
			ecf_xdoc: EL_XML_DOC_CONTEXT
		do
			ecf_xdoc := new_ecf_xdoc ("library/override/ES-vision2.pecf")
			assert_parsed_xdoc (ecf_xdoc)
		end

	test_c_externals_path
		-- library/image-utils.pecf
		local
			ecf_xdoc: EL_XML_DOC_CONTEXT; count: INTEGER
			condition, location, l_xpath, copy_value, platform: STRING
		do
			ecf_xdoc := new_ecf_xdoc ("library/image-utils.pecf")
			assert_parsed_xdoc (ecf_xdoc)

			create location.make_empty
			condition := "condition/platform/@value='windows'"
			across ecf_xdoc.context_list (Xpath.external_object #$ [condition]) as target loop
				count := count + 1
				if count = 2 then
					location := target.node ["location"]
				end
			end
			assert ("valid_location", count = 2 and location.ends_with ("libcairo-2.dll"))

			l_xpath := "/system/target/external_object [condition/custom [@name='shared']/@value='true']"
			count := 0
			across ecf_xdoc.context_list (l_xpath) as external_object loop
				count := count + 1
				lio.put_labeled_string ("Description", external_object.node.query ("description").as_string)
				lio.put_new_line
				copy_value := external_object.node.query (Xpath.custom_value #$ ["copy"])
				inspect count
					when 1, 3 then
						assert ("copy is $location", copy_value ~ "$location")
					when 2 then
						assert ("copy is $location", copy_value ~ "$EL_C_CAIRO/spec/$ISE_PLATFORM/*.dll")
				end
				platform := external_object.node.query ("condition/platform/@value")
				inspect count
					when 1, 2 then
						assert ("platform is windows", platform ~ "windows")
					when 3 then
						assert ("platform is unix", platform ~ "unix")
				end
			end
			assert ("shared external_object count = 3", count = 3)

			count := 0; location.wipe_out
			across ecf_xdoc.context_list (Xpath.external_include #$ ["unix"]) as target loop
				count := count + 1
				if count = 4 then
					location := target.node ["location"]
				end
			end
			assert ("valid_location", count = 4 and location.ends_with ("glib-2.0/include"))
		end

	test_eiffel2java_pecf
		note
			testing: "covers/{WRITEABLE_LIBRARIES_ECF_LINES}.set_from_line",
						"covers/{LIBRARIES_ECF_LINES}.set_from_line",
						"covers/{RENAMING_MAP_ECF_LINES}.set_from_line",
						"covers/{CLUSTER_TREE_ECF_LINES}.set_from_line",
						"covers/{PLATFORM_FILE_RULE_ECF_LINES}.set_from_line",
						"covers/{SYSTEM_ECF_LINES}.set_from_line"
		local
			ecf_xdoc: EL_XML_DOC_CONTEXT; file_rule_count, windows_count: INTEGER
			schema_location, platform_value, exclude_value, library_target: STRING
		do
			ecf_xdoc := new_ecf_xdoc ("library/eiffel2java.pecf")
			assert_parsed_xdoc (ecf_xdoc)

			create library_target.make_empty
			across ecf_xdoc.context_list ("/system[@name='EL_eiffel2java']") as system loop
				library_target := system.node ["library_target"]
				assert ("library_target = EL_eiffel2java", library_target ~ "EL_eiffel2java")
			end
			assert ("library_target found", library_target.count > 0)

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

			if attached ecf_xdoc.find_node ("//library [@name='eiffel2java']") as library then
				across Renaming_table as table loop
					assert ("valid new_name", library.query (Xpath.renaming_new_name #$ [table.key]).as_string_8 ~ table.item)
				end
				assert ("is eiffel2java", library ["name"].as_string ~ "eiffel2java")
			else
				assert ("eiffel2java library found", False)
			end
			if attached ecf_xdoc.query ("/system/target/cluster[@name='Java']/@location").as_string_8 as location then
				assert ("Java cluster", location.ends_with ("Java"))
			end

			assert ("valid default namespace", ecf_xdoc.namespace_table ["default"].ends_with ("xml/configuration-1-16-0"))
			assert ("valid xsi namespace", ecf_xdoc.namespace_table ["xsi"].ends_with ("XMLSchema-instance"))

			ecf_xdoc.set_namespace_key ("xsi")
			schema_location := ecf_xdoc.query ("@xsi:schemaLocation")
			assert ("valid xsi:schemaLocation", schema_location.ends_with ("configuration-1-16-0.xsd"))
		end

	test_eiffel_pecf
		local
			ecf_xdoc: EL_XML_DOC_CONTEXT; sub_cluster_count, writeable_count: INTEGER
			name, location: STRING; has_i18n: BOOLEAN
		do
			ecf_xdoc := new_ecf_xdoc ("tool/eiffel/eiffel.pecf")
			assert_parsed_xdoc (ecf_xdoc)

			assert ("22 libraries", library_count (ecf_xdoc) = 22)
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
			across ecf_xdoc.context_list ("//library[@readonly='false']") as writeable loop
				if writeable.node ["name"].as_string_8 ~ "EL_i18n" then
					assert ("precondition true", writeable.node.query ("option/assertions/@precondition").as_string_8 ~ "true")
					has_i18n := True
				end
				writeable_count := writeable_count + 1
			end
			assert ("has EL_i18n", has_i18n)
			assert ("17 writeable", writeable_count = 17)
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

	test_excluded_value_conditions
		-- override/ES-cURL.ecf
		local
			ecf_xdoc: EL_XML_DOC_CONTEXT; condition: STRING
			count: INTEGER
		do
			ecf_xdoc := new_ecf_xdoc ("library/override/ES-cURL.pecf")
			assert_parsed_xdoc (ecf_xdoc)

			across Condition_table as table loop
				condition := table.key; count := 0
				across ecf_xdoc.context_list (Xpath.external_object #$ [condition]) as list loop
					count := count + 1
				end
				lio.put_integer_field (condition, count)
				lio.put_new_line
				assert ("valid count " + condition, count = table.item)
			end
		end

	test_graphical_pecf
		local
			ecf_xdoc: EL_XML_DOC_CONTEXT; name, l_xpath: STRING
			location_steps: EL_PATH_STEPS
		do
			ecf_xdoc := new_ecf_xdoc ("example/graphical/graphical.pecf")
			assert_parsed_xdoc (ecf_xdoc)

			assert ("17 libraries", library_count (ecf_xdoc) = 17)
			across ("__unnamed_debug__, wel_gdi_references, win_dispatcher").split (',') as list loop
				name := list.item; name.left_adjust
				assert ("debug false", ecf_xdoc.query (Xpath.named_option #$ ["debug", name]).as_string_8 ~ "false")
			end
			across ("export_class_missing, vjrv").split (',') as list loop
				name := list.item; name.left_adjust
				assert ("warning false", ecf_xdoc.query (Xpath.named_option #$ ["warning", name]).as_string_8 ~ "false")
			end
			across <<
				"address_expression", "array_optimization", "dynamic_runtime",
				"exception_trace", "inlining", "line_generation" >> as list
			loop
				assert ("false", ecf_xdoc.query (Xpath.setting #$ [list.item]).as_string_8 ~ "false")
			end
			across ("check_vape, dead_code_removal, console_application").split (',') as list loop
				name := list.item; name.left_adjust
				assert ("true", ecf_xdoc.query (Xpath.setting #$ [name]).as_string_8 ~ "true")
			end
			assert ("true", ecf_xdoc.query (Xpath.setting #$ ["concurrency"]).as_string_8 ~ "thread")

			across Library_table as table loop
				l_xpath := Xpath.library_location #$ [table.key]
				location_steps := ecf_xdoc.query (l_xpath).as_file_path
				assert ("is library path", location_steps.item (2).same_string ("library"))
				assert (table.key, location_steps.base.same_string (table.item))
			end
			assert ("is GUI-application.ecf", has_precompile (ecf_xdoc, "GUI-application.ecf"))
		end

feature {NONE} -- Implementation

	assert_parsed_xdoc (ecf_xdoc: EL_XML_DOC_CONTEXT)
		do
			assert (ecf_xdoc.file_path.base + " parsed OK", not ecf_xdoc.parse_failed)
		end

	has_precompile (ecf_xdoc: EL_XML_DOC_CONTEXT; name: STRING): BOOLEAN
		do
			if attached ecf_xdoc.find_node ("/system/target/precompile[@name='precompile']") as precompile then
				Result := precompile ["location"].as_string_8.ends_with (name)
			end
		end

	library_count (ecf_xdoc: EL_XML_DOC_CONTEXT): INTEGER
		do
			Result := ecf_xdoc.context_list ("//library").count
		end

	new_ecf_xdoc (pecf_path: FILE_PATH): EL_XML_DOC_CONTEXT
		local
			converter: PYXIS_ECF_CONVERTER
		do
			create converter.make (
				Dev_environ.Eiffel_loop_dir + pecf_path, Work_area_dir + (pecf_path.base_sans_extension + ".xml")
			)
			converter.execute
			create Result.make_from_file (converter.output_path)
		end

feature {NONE} -- Constants

	Condition_table: EL_HASH_TABLE [INTEGER, STRING]
		once
			create Result.make (<<
				["condition/platform/@value='windows'", 4],
				["condition/platform/@excluded_value='windows'", 2],
				["condition/dotnet/@value='false'", 2],
				["condition/concurrency/@excluded_value='none'", 2]
			>>)
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

	Renaming_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["JNI_ENVIRONMENT", "JAVA_ORB"],
				["SHARED_JNI_ENVIRONMENT", "JAVA_SHARED_ORB"]
			>>)
		end

	Xpath: TUPLE [
		custom_value, external_include, external_object, library_location, named_option, renaming_new_name,
		setting: ZSTRING
	]
		once
			create Result
			Result.custom_value := "condition/custom [@name='%S']/@value"
			Result.external_include := "/system/target/external_include[condition/platform/@value='%S']"
			Result.external_object := "/system/target/external_object[%S]"
			Result.library_location := "/system/target/library[@name='%S']/@location"
			Result.named_option := "/system/target/option/%S[@name='%S']/@enabled"
			Result.renaming_new_name := "renaming[@old_name='%S']/@new_name"
			Result.setting := "/system/target/setting[@name='%S']/@value"
		end

	Valid_platforms: EL_STRING_8_LIST
		once
			Result := "unix, windows"
		end

end