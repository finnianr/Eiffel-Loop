note
	description: "Java test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:16:17 GMT (Tuesday 10th November 2020)"
	revision: "8"

class
	JAVA_TEST_APP

inherit
	REGRESSION_TESTABLE_SUB_APPLICATION

	SHARED_JNI_ENVIRONMENT

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			Console.show_all (<<
				{JAVA_ENVIRONMENT_IMP},
				{J_INT}, {J_STRING}, {J_LINKED_LIST}, {J_OBJECT}, {J_VELOCITY},
				{J_VELOCITY_CONTEXT}, {J_TEMPLATE}, {JAVA_DEPLOYMENT_PROPERTIES}
			>>)
		end

feature -- Basic operations

	normal_run
		do

		end

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "class" >>)
			Test.do_file_tree_test ("java_classes", agent call_java_classes, 430205812)
--			Test.do_file_test ("java_source/deployment.properties", agent read_deployment_file, 1966068268)
		end

feature -- Test

	call_java_classes (source_path: EL_DIR_PATH)
			--
		do
			log.enter_with_args ("call_java_classes", [source_path])
			Java.append_class_locations (<< source_path >>)
			Java.open (<< >>)

			many_references_test

			Java.close

			log.exit
		end

feature {NONE} -- Implementation

	extra_log_filter_set: EL_LOG_FILTER_SET [J_J2E_TEST_TARGET]
		do
			create Result.make
		end

	many_references_test
			-- See what happens if we have 1000+ references to Java Objects
		local
			j2e_test: J_J2E_TEST_TARGET; java_string_list: J_LINKED_LIST
			string_list: LINKED_LIST [J_STRING]; i: INTEGER
		do
			log.enter ("many_references_test")
			create j2e_test.make
			create string_list.make
			from
				java_string_list := j2e_test.string_list -- List of 1000 strings
				log.put_new_line
			until
				java_string_list.is_empty.value.item
			loop
				string_list.extend (create {J_STRING}.make_from_java_object (java_string_list.remove_first))
			end

			from
				string_list.start
				i := 1
			until
				string_list.off
			loop
				if i \\ 100 = 0 then
					log.put_string (
						string_list.item.value
					)
					log.put_new_line
				end
				i := i + 1
				string_list.forth
			end
			log.exit
		end

feature {NONE} -- Constants

	Option_name: STRING = "java_test"

	Description: STRING = "Basic Java access tests"

end
