note
	description: "Test [$source J_VELOCITY] and related classes to wrap Java Apache Velocity package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-09 9:55:55 GMT (Monday 9th January 2023)"
	revision: "5"

class
	VELOCITY_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EL_MODULE_FILE; EL_MODULE_JAVA

	SHARED_JNI_ENVIRONMENT undefine default_create end

	SHARED_DEV_ENVIRON

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("velocity", agent test_velocity)
		end

feature -- Tests

	test_velocity
		do
			Java.append_jar_locations (<< Dev_environ.Eiffel_loop_dir #+ "contrib/Java/velocity-1.7" >>)
			Java.open (<< "velocity-1.7-dep" >>)
			do_velocity_test
			Java.close
			assert ("all Java objects released", jorb.object_count = 0)
		end

feature {NONE} -- Implementation

	assert_valid_manifest (directory_list: EL_DIRECTORY_PATH_LIST; manifest_text: ZSTRING)
		local
			element: ZSTRING
		do
			lio.enter ("assert_valid_manifest")
			across directory_list as list loop
				element := Directory_element #$ [list.item]
				lio.put_labeled_string ("Checking", element)
				lio.put_new_line
				assert ("output has directory element", manifest_text.has_substring (element))
				across OS.file_list (list.item, "*.e") as l_path loop
					element := Class_element #$ [l_path.item.base_name.as_upper]
					assert ("output has class element", manifest_text.has_substring (element))
				end
			end
			lio.exit
		end

	do_velocity_test
			--
		local
			directory_list: EL_DIRECTORY_PATH_LIST
			string_writer: J_STRING_WRITER; file_writer: J_FILE_WRITER
			output_path: FILE_PATH; dir_name_map_list: like new_dir_name_map_list
		do
			create directory_list.make (work_area_data_dir)
			create string_writer.make

			dir_name_map_list := new_dir_name_map_list (directory_list)
			write_merged_template (dir_name_map_list, "test-data/manifest-xml.vel", string_writer)
			assert_valid_manifest (directory_list, string_writer.to_string.value)
			lio.put_new_line

			output_path := work_area_dir + "J_FILE_WRITER-manifest.xml"
			create file_writer.make_from_string (output_path.to_string)
			write_merged_template (dir_name_map_list, "test-data/manifest-xml.vel", file_writer)
			file_writer.close
			assert_valid_manifest (directory_list, File.plain_text (output_path))

		end

	write_merged_template (dir_name_map_list: J_LINKED_LIST; template_path: EL_FILE_PATH; writer: J_WRITER)
		local
			template: J_TEMPLATE; velocity_app: J_VELOCITY; context: J_VELOCITY_CONTEXT
		do
			lio.enter_with_args ("write_merged_template", [writer.generator])
			create velocity_app.make
			create context.make

			velocity_app.init

			call_java (context.put_string ("library_name", "base"))
			call_java (context.put_object ("directory_list", dir_name_map_list))
			template := velocity_app.template (template_path.to_string)

			template.merge (context, writer)
			lio.exit
		end

	new_dir_name_map_list (directory_list: LIST [EL_DIR_PATH]): J_LINKED_LIST
		local
			dir_name_map: J_HASH_MAP
			path_string, class_name_list_string: J_STRING
		do
			create Result.make
			path_string := "path"; class_name_list_string := "class_name_list"
			across directory_list as dir loop
				create dir_name_map.make
				call_java (dir_name_map.put_string (path_string, dir.item.to_string))
				call_java (dir_name_map.put (class_name_list_string, class_list (dir.item)))
				Result.add_last (dir_name_map)
			end
		end

feature {NONE} -- Implementation

	call_java (returned_value: J_OBJECT)
			-- Do nothing procedure to throw away return value of Java call
		do
		end

	class_list (location: EL_DIR_PATH): J_LINKED_LIST
			--
		local
			class_name: ZSTRING
		do
			create Result.make
			across OS.file_list (location, "*.e") as l_path loop
				class_name := l_path.item.base_name.as_upper
				Result.add_last_string (class_name)
			end
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (work_area_data_dir, "*.e")
		end

feature {NONE} -- Constants

	Class_element: ZSTRING
		once
			Result := "[
				<class name="#"/>
			]"
		end

	Directory_element: ZSTRING
		once
			Result := "[
				<directory location="#">
			]"
		end

	Source_dir: EL_DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir #+ "tool/eiffel/test-data/sources/latin-1"
		end
end