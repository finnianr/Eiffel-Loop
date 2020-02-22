note
	description: "Demo of accessing Java Velocity package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-20 17:57:28 GMT (Thursday 20th February 2020)"
	revision: "6"

class
	APACHE_VELOCITY_TEST_APP

inherit
	REGRESSION_TESTABLE_SUB_APPLICATION
		rename
			extra_log_filter as no_log_filter
		end

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			Console.show ({JAVA_PACKAGE_ENVIRONMENT_IMP})
			Java_packages.append_jar_locations (<< eiffel_loop_dir.joined_dir_path ("contrib/Java/velocity-1.7") >>)
			Java_packages.open (<< "velocity-1.7-dep" >>)
		end

feature -- Basic operations

	normal_run
		do
		end

	test_run
			--
		do
			normal_initialize
			Test.do_file_tree_test ("Eiffel", agent write_class_manifest, 3687286250)
			OS.delete_file (create {EL_FILE_PATH}.make ("velocity.log"))
			Java_packages.close
		end

feature -- Test

	write_class_manifest (source_path: EL_DIR_PATH)
			--
		do
			log.enter_with_args ("write_class_manifest", [source_path])
			write_manifest (source_path)
			log.exit
		end

feature {NONE} -- Implementation

	write_manifest (source_path: EL_DIR_PATH)
			--
		local
			directory_list: EL_DIRECTORY_PATH_LIST; output_path: EL_FILE_PATH

			string_writer: J_STRING_WRITER; file_writer: J_FILE_WRITER
			velocity_app: J_VELOCITY; context: J_VELOCITY_CONTEXT

			l_directory_list: J_LINKED_LIST; template: J_TEMPLATE
			l_string_path, l_string_class_name_list: J_STRING
			l_directory_name_scope: J_HASH_MAP
		do
			log.enter ("write_manifest")

			create directory_list.make (source_path)
			output_path := source_path + "Java-out.Eiffel-library-manifest.xml"

			create l_string_path.make_from_utf_8 ("path")
			create l_string_class_name_list.make_from_utf_8 ("class_name_list")

			create string_writer.make
			create file_writer.make_from_string (output_path.to_string)
			create velocity_app.make
			create context.make
			create l_directory_list.make

			across directory_list as dir loop
				create l_directory_name_scope.make
				java_line (
					l_directory_name_scope.put_string (l_string_path, dir.item.to_string)
				)
				java_line (
					l_directory_name_scope.put (l_string_class_name_list, class_list (dir.item))
				)
				l_directory_list.add_last (l_directory_name_scope)
			end

			velocity_app.init

			java_line (
				context.put_string ("library_name", "base")
			)
			java_line (
				context.put_object ("directory_list", l_directory_list)
			)
			template := velocity_app.template ("manifest-xml.vel")

			template.merge (context, string_writer)
			template.merge (context, file_writer)
			file_writer.close
			log.put_string (string_writer.to_string.value)
			log.put_new_line

			log.exit
		end

	class_list (location: EL_DIR_PATH): J_LINKED_LIST
			--
		local
			class_name: ZSTRING
		do
			create Result.make
			across OS.file_list (location, "*.e") as file_path loop
				class_name := file_path.item.base_sans_extension.as_upper
				Result.add_last_string (class_name)
			end
		end

	java_line (returned_value: J_OBJECT)
			-- Do nothing procedure to throw away return value of Java call
		do
		end

feature {NONE} -- Constants

	Option_name: STRING = "apache_velocity"

	Description: STRING = "Create and XML manifest of Eiffel base library"

end
