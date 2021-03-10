note
	description: "Java object reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:00:15 GMT (Wednesday 10th March 2021)"
	revision: "5"

deferred class
	JAVA_OBJECT_REFERENCE

inherit
	JAVA_PACKAGE

	JAVA_TYPE
		redefine
			make, make_from_java_method_result
		end

	JAVA_OBJECT_ATTRIBUTES undefine is_equal end

	JAVA_OBJECT_METHOD_CALLS undefine is_equal end

	JAVA_OBJECT_OR_CLASS undefine is_equal end

	EL_MEMORY
		undefine
			is_equal
		redefine
			dispose
		end

	EL_MODULE_NAMING

feature {NONE} -- Initialization

	make
			--
		local
			constructor_id, null_ptr: POINTER
		do
			constructor_id := method_id ("<init>", "()V")
			make_from_pointer (
				jorb.new_object (jclass.java_class_id, constructor_id, null_ptr)
			)
		ensure then
			is_attached_to_java_object: is_attached_to_java_object
		end

	make_from_java_attribute (target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER)
			--
		do
			make_from_pointer (target.object_attribute (a_field_id))
		end

	make_from_java_method_result (target: JAVA_OBJECT_OR_CLASS; a_method_id: POINTER; args: JAVA_ARGUMENTS)
			--
		do
			make_from_pointer (target.object_method (a_method_id, args))
		end

	make_from_java_object (j_object: J_OBJECT)
			--
		require
			is_assignable_from (j_object)
		do
			make_from_pointer (j_object.java_object_id)
		end

	make_from_pointer (jobject: POINTER)
			-- Called from other contructors
		do
			java_object_id := jobject
			if is_attached (java_object_id) then
				jorb.increment_object_ref_count (java_object_id)
				debug ("jni")
					jorb.object_names [java_object_id] := jni_type_signature
				end
			else
				java_object_id := Java_void
			end
		end

feature -- Status report

	Java_void: POINTER
			--
		once
			Result := Default_pointer + 1
		end

	is_attached_to_java_object: BOOLEAN
			-- Is eiffel proxy attached to java object?
		do
			Result := java_object_id /= Java_void
		end

feature -- Conversion

	to_java_lang_object: J_OBJECT
			--
		do
			create Result.make_from_pointer (java_object_id)
		end

feature -- Comparison

	is_assignable_from (other: like Current): BOOLEAN
			-- Can current java object be assigned from other java object
			-- eg. String s = (String)list.removeLast();
		do
			Result := jorb.is_assignable_from (
				jclass.java_class_id, other.jclass.java_class_id
			)
		end

feature {NONE} -- Disposal

	dispose
			--
		do
			if is_lio_enabled then
				lio.put_labeled_string ("disposing", generator)
				lio.put_new_line
			end
			if is_attached_to_java_object then
				jorb.decrement_object_ref_count (java_object_id)
			end
		end

feature {JAVA_ROUTINE} -- Implementation

	field_id (lname: STRING; sig: STRING): POINTER
			-- Get the java field id used to set/get this field
		local
			lname_to_c, sig_to_c: C_STRING
		do
			create lname_to_c.make (lname)
			create sig_to_c.make (sig)
			Result := jorb.get_field_id (jclass.java_class_id, lname_to_c.item, sig_to_c.item)
		end

	method_id (feature_name: STRING; signature: STRING): POINTER
			-- Find the method_id for `feature_name' with signature
			-- encoded by "signature"
		local
			method_name_to_c, signature_to_c: C_STRING
		do
			create method_name_to_c.make (feature_name)
			create signature_to_c.make (signature)
			Result := jorb.get_method_id (jclass.java_class_id, method_name_to_c.item, signature_to_c.item)
		end

feature {JAVA_OBJECT_REFERENCE} -- Implementation

	set_argument (argument: JAVA_VALUE)
			--
		do
			argument.set_object_value (java_object_id)
		end

	new_jclass: JAVA_CLASS_REFERENCE
		do
			create Result.make (package_name, new_jclass_name)
		end

	new_jclass_name: STRING
		do
			Result := Naming.class_as_camel (Current, 1, 0)
		end

feature -- Access

	java_object_id: POINTER
		-- Reference to java object.

	jclass: JAVA_CLASS_REFERENCE
			-- Associated java class.
		do
			Result := Class_reference_by_type.item (Current)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := java_object_id = other.java_object_id
		end

feature -- Constant

	Jni_type_signature: STRING
				-- a fully-qualified class name (that is, a package name, delimited by "/",
				-- followed by the class name).
				-- If the name begins with "[" (the array jni_type_name character),
				-- it returns an array class.
		do
			create Result.make_from_string (jclass.qualified_jni_class_name)
			Result.prepend_character ('L')
			Result.append_character (';')
		end

feature -- Attributes setting

	set_boolean_attribute (fid: POINTER; value: BOOLEAN)
			-- Set a 'boolean' attribute to 'value'
		do
			jorb.set_boolean_field (java_object_id, fid, value)
		end

	set_byte_attribute (fid: POINTER; value: INTEGER_8)
			-- Set a 'byte' attribute to 'value'
		do
			jorb.set_byte_field (java_object_id, fid, value)
		end

	set_char_attribute (fid: POINTER; value: CHARACTER)
			-- Set a 'char' attribute to 'value'
		do
			jorb.set_char_field (java_object_id, fid, value)
		end

	set_double_attribute (fid: POINTER; value: DOUBLE)
			-- Set a 'double' attribute to 'value'
		do
			jorb.set_double_field (java_object_id, fid, value)
		end

	set_float_attribute (fid: POINTER; value: REAL)
			-- Set a 'float' attribute to 'value'
		do
			jorb.set_float_field (java_object_id, fid, value)
		end

	set_integer_attribute (fid: POINTER; value: INTEGER)
			-- Set an 'integer' attribute to 'value'
		do
			jorb.set_integer_field (java_object_id, fid, value)
		end

	set_long_attribute (fid: POINTER; value: INTEGER_64)
			-- Set a 'short' attribute to 'value'
		do
			jorb.set_long_field (java_object_id, fid, value)
		end

	set_object_attribute (fid: POINTER; value: JAVA_OBJECT)
			-- Set a java object attribute to 'value'
		do
			jorb.set_object_field (java_object_id, fid, value.java_object_id)
		end

	set_short_attribute (fid: POINTER; value: INTEGER_16)
			-- Set a 'short' attribute to 'value'
		do
			jorb.set_short_field (java_object_id, fid, value)
		end

	set_string_attribute (fid: POINTER; value: STRING)
			-- Set a 'String' attribute to 'value'
		do
			jorb.set_string_field (java_object_id, fid, value)
		end

feature {NONE} -- Constants

	Class_reference_by_type: EL_FUNCTION_RESULT_TABLE [JAVA_OBJECT_REFERENCE, JAVA_CLASS_REFERENCE]
		once
			create Result.make (11, agent {JAVA_OBJECT_REFERENCE}.new_jclass)
		end

end