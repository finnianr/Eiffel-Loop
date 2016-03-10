note
	description: "Demo of accessing Java Velocity package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 20:07:59 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	APACHE_VELOCITY_TEST_APP

inherit
	TESTABLE_JAVA_APPLICATION

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			Java_packages.append_jar_locations (<<
				eiffel_loop_dir.joined_dir_steps (<< "contrib", "Java", "velocity-1.7" >>)
			>>)
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
			Test.do_file_tree_test ("sample-source", agent write_class_manifest, 3687286250)
			File_system.delete (create {EL_FILE_PATH}.make ("velocity.log"))
			Java_packages.close
		end

feature -- Test

	write_class_manifest (source_path: EL_DIR_PATH)
			--
		do
			log.enter_with_args ("write_class_manifest", << source_path >>)
			write_manifest (source_path)
			log.exit
		end

feature {NONE} -- Implementation

	write_manifest (source_path: EL_DIR_PATH)
			--
		local
			directory_list: EL_DIRECTORY_PATH_LIST
			output_path: EL_FILE_PATH

			string_writer: J_STRING_WRITER
			file_writer: J_FILE_WRITER
			velocity_app: J_VELOCITY
			context: J_VELOCITY_CONTEXT
			template: J_TEMPLATE
			l_directory_list: J_LINKED_LIST
			l_string_path, l_string_class_name_list: J_STRING
			l_directory_name_scope: J_HASH_MAP
		do
			log.enter ("write_manifest")

			create directory_list.make (source_path)
			output_path := source_path + "Java-out.Eiffel-library-manifest.xml"

			create l_string_path.make_from_string ("path")
			create l_string_class_name_list.make_from_string ("class_name_list")

			create string_writer.make
			create file_writer.make_from_string (output_path.to_string.to_latin1)
			create velocity_app.make
			create context.make
			create l_directory_list.make

			across directory_list as dir loop
				create l_directory_name_scope.make
				java_line (
					l_directory_name_scope.put_string (l_string_path, dir.item.to_string.to_latin1)
				)
				java_line (
					l_directory_name_scope.put (l_string_class_name_list, class_list (directory_list.path))
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
			class_name: EL_ASTRING
		do
			create Result.make
			across File_system.file_list (location, "*.e") as file_path loop
				class_name := file_path.item.without_extension.base.as_upper
				Result.add_last_string (class_name.to_latin1)
			end
		end

	java_line (returned_value: J_OBJECT)
			-- Do nothing procedure to throw away return value of Java call
		do
		end

feature {NONE} -- Constants

	Option_name: STRING = "apache_velocity_test"

	Description: STRING = "Create and XML manifest of Eiffel base library"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{APACHE_VELOCITY_TEST_APP}, "*"],
				[{JAVA_PACKAGE_ENVIRONMENT}, "*"],
				[{EL_TEST_ROUTINES}, "*"]
			>>
		end

end