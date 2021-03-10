note
	description: "Test [$source J_VELOCITY] and related classes to wrap Java Apache Velocity package"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VELOCITY_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_JAVA

	SHARED_JNI_ENVIRONMENT undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("velocity", agent test_velocity)
		end

feature -- Tests

	test_velocity
			--
		local
			directory_list: EL_DIRECTORY_PATH_LIST
		do
			Java.append_jar_locations (<< Eiffel_loop_dir.joined_dir_path ("contrib/Java/velocity-1.7") >>)
			Java.open (<< "velocity-1.7-dep" >>)

			create directory_list.make (work_area_data_dir)
			write_merged_template (
				directory_list, work_area_data_dir + "Java-out.Eiffel-library-manifest.xml",
				"test-data/manifest-xml.vel"
			)

			Java.close
			assert ("all Java objects released", jorb.object_count = 0)
		end

feature {NONE} -- Implementation

	write_merged_template (directory_list: LIST [EL_DIR_PATH]; output_path, template_path: EL_FILE_PATH)
		local
			string_writer: J_STRING_WRITER; file_writer: J_FILE_WRITER
			velocity_app: J_VELOCITY; context: J_VELOCITY_CONTEXT

			l_directory_list: J_LINKED_LIST; template: J_TEMPLATE
			l_string_path, l_string_class_name_list: J_STRING
			l_directory_name_scope: J_HASH_MAP
			output_text, element: ZSTRING
		do
			l_string_path := "path"
			l_string_class_name_list := "class_name_list"

			create string_writer.make
			create file_writer.make_from_string (output_path.to_string)
			create velocity_app.make
			create context.make
			create l_directory_list.make

			across directory_list as dir loop
				create l_directory_name_scope.make
				lio.put_path_field ("Adding", dir.item)
				lio.put_new_line
				call (l_directory_name_scope.put_string (l_string_path, dir.item.to_string))
				call (l_directory_name_scope.put (l_string_class_name_list, class_list (dir.item)))
				l_directory_list.add_last (l_directory_name_scope)
			end

			velocity_app.init

			call (context.put_string ("library_name", "base"))
			call (context.put_object ("directory_list", l_directory_list))
			template := velocity_app.template (template_path.to_string)

			lio.put_line ("Merging Java templates")
			template.merge (context, string_writer)
			template.merge (context, file_writer)
			file_writer.close
			output_text := string_writer.to_string.value
			-- check output text
			across directory_list as list loop
				element := Directory_element #$ [list.item]
				lio.put_labeled_string ("Checking directory", element)
				lio.put_new_line
				assert ("output has directory element", output_text.has_substring (element))
				across OS.file_list (list.item, "*.e") as l_path loop
					element := Class_element #$ [l_path.item.base_sans_extension.as_upper]
					assert ("output has class element", output_text.has_substring (element))
				end
			end
		end

feature {NONE} -- Implementation

	call (returned_value: J_OBJECT)
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
				class_name := l_path.item.base_sans_extension.as_upper
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
			Result := "<class name=%"%S%"/>"
		end

	Directory_element: ZSTRING
		once
			Result := "<directory location=%"%S%">"
		end

	Source_dir: EL_DIR_PATH
		once
			Result := Eiffel_loop_dir.joined_dir_path ("tool/eiffel/test-data/latin1-sources")
		end
end
