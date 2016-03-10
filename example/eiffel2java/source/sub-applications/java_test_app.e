note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:16 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	JAVA_TEST_APP

inherit
	TESTABLE_JAVA_APPLICATION

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
		end

feature -- Basic operations

	normal_run
		do

		end

	test_run
			--
		do
			Test.do_file_tree_test ("java_classes", agent call_java_classes, 430205812)
			Test.do_file_test ("java_source/deployment.properties", agent read_deployment_file, 1966068268)
		end

feature -- Test

	call_java_classes (source_path: EL_DIR_PATH)
			--
		do
			log.enter_with_args ("call_java_classes", << source_path >>)
			Java_packages.append_class_locations (<< source_path >>)
			Java_packages.open (<< >>)

			basic_tests_1
			basic_tests_2
			many_references_test
			garbage_disposal_tests

			Java_packages.close

			log.exit
		end

	read_deployment_file (file_path: EL_FILE_PATH)
		local
			properties: JAVA_DEPLOYMENT_PROPERTIES
		do
			log.enter_with_args ("read_deployment_file", << file_path >>)
			create properties.make (file_path)
			properties.dump
			log.exit
		end

feature {NONE} -- Implementation

	basic_tests_1
			-- Basic Eiffel2Java library test
		local
			class_test: JAVA_CLASS
			instance_of_class_test: JAVA_OBJECT
			fid: POINTER
			value: INTEGER
		do
			log.enter ("basic_tests_1")

			class_test := Java_packages.jorb.find_class ("J2ETestTarget")

			log.put_new_line
			log.put_string ("Creating instance of class `test")
			create instance_of_class_test.create_instance (class_test, "()V", Void)

				--| Access to a public attribute
				-- 'fid' contains the id of the field 'my_integer'
			fid := instance_of_class_test.field_id ("my_integer", "I")
				-- 'value' contains the value of the field referenced by 'fid'
			value := instance_of_class_test.integer_attribute (fid)

			log.put_new_line
			log.put_string ("Value of `my_integer' is " + value.out)

				--| Access to a static attribute using directly the JAVA_CLASS_REFERENCE
			fid := class_test.field_id ("my_static_integer", "I")
			value := class_test.integer_attribute (fid)

			log.put_new_line
			log.put_string ("Value of `my_static_integer' is " + value.out)

			fid := instance_of_class_test.field_id ("my_integer", "I")
				-- 'value' contains the value of the field referenced by 'fid'
			value := instance_of_class_test.integer_attribute (fid)

			log.put_new_line
			log.put_string ("Value of `my_integer' after call to `my_method' is " + value.out)

				--| Access to a static attribute using directly the JAVA_CLASS_REFERENCE
			fid := class_test.field_id ("my_static_integer", "I")
			value := class_test.integer_attribute (fid)

			log.put_new_line
			log.put_string ("Value of `my_static_integer' after call to `my_method' is " + value.out )

			log.put_new_line
			Java_packages.jorb.delete_local_ref (instance_of_class_test.java_object_id)
			log.exit
		end

	basic_tests_2
			--
		local
			j2e_test: J_J2E_TEST_TARGET
			num_1, num_2, num_8255: J_INT
			hello_msg, str: J_STRING
			jfloat_value: J_FLOAT
		do
			log.enter ("basic_tests_2")

			create j2e_test.make
			create num_8255.make_from_integer (8255370)
			create hello_msg.make_from_string ("Hello world!")

			jfloat_value := j2e_test.my_function (num_8255, hello_msg)
			j2e_test.my_method (num_8255, hello_msg)
			num_1 := j2e_test.my_integer
			num_2 := j2e_test.my_static_integer

			create j2e_test.make_from_string (hello_msg)
--			num_1 := j2e_test.my_integer
			create str.make_from_java_object (j2e_test.my_string)

			log.exit
		end

	many_references_test
			-- See what happens if we have 1000+ references to Java Objects
		local
			j2e_test: J_J2E_TEST_TARGET
			java_string_list: J_LINKED_LIST
			string_list: LINKED_LIST [J_STRING]
			i: INTEGER
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
				string_list.extend (
					create {J_STRING}.make_from_java_object (
						java_string_list.remove_first
					)
				)
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

	garbage_disposal_tests
			-- Test that java objects are release with Eiffel garbage collection
		local
			j2e_test: J_J2E_TEST_TARGET
			num_8255:J_INT
			hello_msg: J_STRING
			linked_list: J_LINKED_LIST
			obj_ref_1, obj_ref_2: J_OBJECT
		do
			log.enter ("garbage_disposal_tests")

			create j2e_test.make
			create num_8255.make_from_integer (8255370)
			create hello_msg.make_from_string ("Hello world!")

			create linked_list.make
			linked_list.add_last (j2e_test.to_java_lang_object)
			linked_list.add_last (j2e_test.to_java_lang_object)

			obj_ref_1 := linked_list.remove_first
			obj_ref_2 := linked_list.remove_first
			log.exit
		end

feature {NONE} -- Constants

	Option_name: STRING = "java_test"

	Description: STRING = "Basic Java access tests"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{JAVA_TEST_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{J_J2E_TEST_TARGET}, "*"],
				[{J_INT}, "*"],
				[{J_STRING}, "-*"],
				[{J_LINKED_LIST}, "-*"],
				[{J_OBJECT}, "-*"],
--				[{JAVA_FUNCTION}, "*"], now a generic class
				[{J_VELOCITY}, "*"],
				[{J_VELOCITY_CONTEXT}, "*"],
				[{J_TEMPLATE}, "*"],
				[{JAVA_PACKAGE_ENVIRONMENT}, "*"],
				[{JAVA_DEPLOYMENT_PROPERTIES}, "*"]
			>>
		end

end -- class JAVA_TEST
