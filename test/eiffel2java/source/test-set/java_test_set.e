note
	description: "Basic Java JNI test"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JAVA_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		redefine
			on_clean, on_prepare
		end

	EL_MODULE_JAVA_PACKAGES

	SHARED_JNI_ENVIRONMENT undefine default_create end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("basic_1", agent test_basic_1)
			eval.call ("basic_2", agent test_basic_2)
		end

feature -- Tests

	test_basic_1
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

	test_basic_2
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
			assert ("value is 0.9", jfloat_value.value = 0.9)

			j2e_test.my_method (num_8255, hello_msg)
			num_1 := j2e_test.my_integer
			num_2 := j2e_test.my_static_integer
			assert ("same value", num_1.value = Number)
			assert ("same value", num_2.value = Number)

			create j2e_test.make_from_string (hello_msg)
			str := j2e_test.my_string
			assert ("same string", str.value.same_string (hello) )
		end


feature {NONE} -- Event handling

	on_clean
		do
			Java_packages.close
			Precursor
		end

	on_prepare
		do
			Precursor
			Java_packages.append_class_locations (<< work_area_data_dir >>)
			Java_packages.open (<< >>)
		end

feature {NONE} -- Constants

	Number: INTEGER = 8255370

	Source_dir: EL_DIR_PATH
		once
			Result := "test-data/java_classes"
		end

end
