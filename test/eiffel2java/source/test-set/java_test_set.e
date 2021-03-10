note
	description: "Basic Java JNI test"
	notes: "[
		Because the JVM can only be loaded once we are limited to only one Java test routine
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JAVA_TEST_SET

inherit
	EL_EQA_REGRESSION_TEST_SET

	EL_MODULE_JAVA

	SHARED_JNI_ENVIRONMENT undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("java", agent test_java)
			eval.call ("deployment_properties", agent test_deployment_properties)
		end

feature -- Tests

	test_deployment_properties
		local
			properties_path: EL_FILE_PATH
		do
			properties_path := "test-data/java_source/deployment.properties"
			do_test ("print_properties", 1842240027, agent print_properties, [properties_path])
		end

	print_properties (file_path: EL_FILE_PATH)
		local
			properties: JAVA_DEPLOYMENT_PROPERTIES
		do
			create properties.make (file_path)
			properties.print_to (lio)
		end

	test_java
		-- test basic Java calls
		do
			Java.append_class_locations (<< "test-data/java_classes" >>)
			Java.open (<< >>)

			do_basic_1;
			do_basic_2
			reference_counting_test

			Java.close
			assert ("all Java objects released", jorb.object_count = 0)
		end

feature {NONE} -- Implementation

	call (object: J_OBJECT)
		do
		end

	do_basic_1
		local
			class_test: JAVA_CLASS; instance_of_class_test: JAVA_OBJECT
			fid: POINTER; value: INTEGER
		do
			class_test := Jorb.find_class ("J2ETestTarget")

			lio.put_line ("Creating instance of `class_test'")
			create instance_of_class_test.create_instance (class_test, "()V", Void)

			-- Access to a public attribute
			-- 'fid' contains the id of the field 'my_integer'
			fid := instance_of_class_test.field_id ("my_integer", "I")
			-- 'value' contains the value of the field referenced by 'fid'
			value := instance_of_class_test.integer_attribute (fid)
			assert ("value is 10", value = 10)

			-- Access to a static attribute using directly the JAVA_CLASS_REFERENCE
			fid := class_test.field_id ("my_static_integer", "I")
			value := class_test.integer_attribute (fid)
			assert ("value is 0", value = 0)

			fid := instance_of_class_test.field_id ("my_integer", "I")
			-- 'value' contains the value of the field referenced by 'fid'
			value := instance_of_class_test.integer_attribute (fid)
			assert ("value is 10", value = 10)

			-- Access to a static attribute using directly the JAVA_CLASS_REFERENCE
			fid := class_test.field_id ("my_static_integer", "I")
			value := class_test.integer_attribute (fid)
			assert ("value is 0", value = 0)

			Jni.delete_local_ref (instance_of_class_test.java_object_id)
		end

	do_basic_2
			--
		local
			j2e_test: J_J2E_TEST_TARGET; num_1, num_2, num_8255: J_INT
			hello_msg, str: J_STRING; jfloat_value: J_FLOAT
			hello: STRING
		do
			create j2e_test.make
			create num_8255.make_from_integer (Number)
			assert ("same value", num_8255.value = Number)

			hello := "Hello world!"
			hello_msg := hello
			assert ("same string", hello_msg.value.same_string (hello) )

			jfloat_value := j2e_test.my_function (num_8255, hello_msg)
			lio.put_new_line
			assert ("value is 0.9", jfloat_value.value = 0.9)

			j2e_test.my_method (num_8255, hello_msg)
			lio.put_new_line
			num_1 := j2e_test.my_integer
			num_2 := j2e_test.my_static_integer
			assert ("same value", num_1.value = Number)
			assert ("same value", num_2.value = Number)

			create j2e_test.make_from_string (hello_msg)
			str := j2e_test.my_string
			assert ("same string", str.value.same_string (hello) )
		end

	reference_counting_test
			-- Test that java objects are release with Eiffel garbage collection
		local
			j2e_test: J_J2E_TEST_TARGET; linked_list: J_LINKED_LIST
			str: J_STRING
		do
			lio.enter ("reference_counting_test")

			create j2e_test.make
			str := "Hello"

--			This require some more thought
--			create linked_list.make
--			linked_list.add_last (j2e_test)
--			linked_list.add_last (str)

--			call (linked_list.remove_first)
--			call (linked_list.remove_first)
			lio.exit
		end

feature {NONE} -- Constants

	Number: INTEGER = 8255370;

note
	java_code: "[
		Source for `J2ETestTarget' test class
	
			import java.util.LinkedList;

			public class J2ETestTarget {
				J2ETestTarget () {
					my_integer  = 10;
				}

				J2ETestTarget (String s) {
					my_string = s;
				}

				public int my_integer;

				public String my_string;

				public static int my_static_integer;

				public void my_method (int n, String s) {
					System.out.println ("int n=" + n + ", String s=\""+s + "\"");
					my_static_integer = n;
					my_integer = n;
				}
				public float my_function (int n, String s) {
					System.out.println ("int n=" + n + ", String s=\"" + s + "\"");
					return 0.9f;
				}

				public LinkedList stringList(){
					LinkedList list = new LinkedList();
					for (int i=0; i < 1000; i++){
						list.addLast("String #"+i);
					}
					return list;
				}
			}
	]"

end
