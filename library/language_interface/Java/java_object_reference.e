note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	JAVA_OBJECT_REFERENCE

inherit
	JAVA_PACKAGE

	JAVA_TYPE
		redefine
			make, make_from_java_method_result
		end

	JAVA_OBJECT_OR_CLASS
		undefine
			is_equal
		end

	JAVA_SHARED_ORB
		undefine
			is_equal
		end

	EL_MEMORY
		undefine
			is_equal
		redefine
			dispose
		end

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

	make_from_java_method_result (
		target: JAVA_OBJECT_OR_CLASS; a_method_id: POINTER; args: JAVA_ARGUMENTS
	)
			--
		do
			make_from_pointer (
				target.object_method (a_method_id, args)
			)
		end

	make_from_java_attribute (
		target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER
	)
			--
		do
			make_from_pointer (target.object_attribute (a_field_id))
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

	make_from_java_object (j_object: J_OBJECT)
			--
		require
			is_assignable_from (j_object)
		do
			make_from_pointer (j_object.java_object_id)
		end

feature -- Status report

	is_attached_to_java_object: BOOLEAN
			-- Is eiffel proxy attached to java object?
		do
			Result := java_object_id /= Java_void
		end

	Java_void: POINTER
			--
		once
			Result := Default_pointer + 1
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
			log.enter ("dispose")
			if is_attached_to_java_object then
				jorb.decrement_object_ref_count (java_object_id)
			end
			log.exit
		end

feature {JAVA_ROUTINE} -- Implementation

	method_id (feature_name: STRING; signature: STRING): POINTER
			-- Find the method_id for `feature_name' with signature
			-- encoded by "signature"
		local
			method_name_to_c, signature_to_c: C_STRING
		do
			create method_name_to_c.make (feature_name)
			create signature_to_c.make (signature)
			Result := jorb.get_method_id (jclass.java_class_id,
									   method_name_to_c.item, signature_to_c.item)
		end

	field_id (lname: STRING; sig: STRING): POINTER
			-- Get the java field id used to set/get this field
		local
			lname_to_c, sig_to_c: C_STRING
		do
			create lname_to_c.make (lname)
			create sig_to_c.make (sig)
			Result := jorb.get_field_id (jclass.java_class_id,
									  lname_to_c.item, sig_to_c.item)
		end

feature {NONE} -- Implementation

	set_argument (argument: JAVA_VALUE)
			--
		do
			argument.set_object_value (java_object_id)
		end

feature -- Access

	java_object_id: POINTER
			-- Reference to java object.

	jclass: JAVA_CLASS_REFERENCE
			-- Associated java class.
		deferred
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

feature -- Calls

	object_method (lmethod_id: POINTER; args: JAVA_ARGUMENTS): POINTER
			-- Call an instance function that returns a java pointer
		do
			Result := jorb.call_object_method (java_object_id, lmethod_id, args.to_c)
		end

	void_method (mid: POINTER; args: JAVA_ARGUMENTS)
			-- Call a Java procedure with method_id "mid" and
			-- arguments "args.
		local
			argsp: POINTER
		do
			if args /= Void then
				argsp := args.to_c
			end
			jorb.call_void_method (java_object_id, mid, argsp)
		end

	string_method (mid: POINTER; args: JAVA_ARGUMENTS): STRING
			-- Call an instance function that returns a STRING.
		local
			argsp: POINTER
		do
			if args /= Void then
				argsp := args.to_c
			end
			Result := jorb.call_string_method (java_object_id, mid, argsp)
		end

	integer_method (mid: POINTER; args: JAVA_ARGUMENTS): INTEGER
			-- Call an instance function that returns an INTEGER.
		local
			argsp: POINTER
		do
			if args /= Void then
				argsp := args.to_c
			end
			Result := jorb.call_int_method (java_object_id, mid, argsp)
		end

	short_method (mid: POINTER; args: JAVA_ARGUMENTS): INTEGER_16
			-- Call an instance function that returns a Short (in
			-- Eiffel we still return an INTEGER).
		local
			argsp: POINTER
		do
			if args /= Void then
				argsp := args.to_c
			end
			Result := jorb.call_short_method (java_object_id, mid, argsp)
		end

	long_method (mid: POINTER; args: JAVA_ARGUMENTS): INTEGER_64
			-- Call an instance function that returns an Long. This
			-- function is not implemented.
		local
			argsp: POINTER
		do
			if args /= Void then
				argsp := args.to_c
			end
			Result := jorb.call_long_method (java_object_id, mid, argsp)
		end

	double_method (mid: POINTER; args: JAVA_ARGUMENTS): DOUBLE
			-- Call an instance function that returns a DOUBLE.
		local
			argsp: POINTER
		do
			if args /= Void then
				argsp := args.to_c
			end
			Result := jorb.call_double_method (java_object_id, mid, argsp)
		end

	float_method (mid: POINTER; args: JAVA_ARGUMENTS): REAL
			-- Call an instance function that returns a REAL.
		local
			argsp: POINTER
		do
			if args /= Void then
				argsp := args.to_c
			end
			Result := jorb.call_float_method (java_object_id, mid, argsp)
		end

	char_method (mid: POINTER; args: JAVA_ARGUMENTS): CHARACTER
			-- Call an instance function that returns a char
		do
			Result := jorb.call_char_method (java_object_id, mid, args.to_c)
		end

	boolean_method (mid: POINTER; args: JAVA_ARGUMENTS): BOOLEAN
			-- Call an instance function that returns a boolean
		do
			Result := jorb.call_boolean_method (java_object_id, mid, args.to_c)
		end

	byte_method (mid: POINTER; args: JAVA_ARGUMENTS): INTEGER_8
			-- Call an instance function that return a byte
			-- ( 8-bit integer (signed)), in Eiffel return
			-- a INTEGER_8
		do
			Result := jorb.call_byte_method (java_object_id, mid, args.to_c)
		end

feature -- Attributes

	object_attribute (fid: POINTER): POINTER
			-- Access to a java object attribute
		do
			Result := jorb.get_object_field (java_object_id, fid)
		end

	integer_attribute (fid: POINTER): INTEGER
			-- Access to an integer attribute
		do
			Result := jorb.get_integer_field (java_object_id, fid)
		end

	string_attribute (fid: POINTER): STRING
			-- Access to a String attribute
		do
			Result := jorb.get_string_field (java_object_id, fid)
		end

	boolean_attribute (fid: POINTER): BOOLEAN
			-- Access to a boolean attribute
		do
			Result := jorb.get_boolean_field (java_object_id, fid)
		end

	char_attribute (fid: POINTER): CHARACTER
			-- Access to a 'char' attribute
		do
			Result := jorb.get_char_field (java_object_id, fid)
		end

	float_attribute (fid: POINTER): REAL
			-- Access to a 'float' attribute, returns a REAL
		do
			Result := jorb.get_float_field (java_object_id, fid)
		end

	double_attribute (fid: POINTER): DOUBLE
			-- Access to a double attribute
		do
			Result := jorb.get_double_field (java_object_id, fid)
		end

	byte_attribute (fid: POINTER): INTEGER_8
			-- Access to a 'byte' attribute, returns a INTEGER_8
		do
			Result := jorb.get_byte_field (java_object_id, fid)
		end

	short_attribute (fid: POINTER): INTEGER_16
			-- Access to a 'short' attribute, returns a INTEGER_16
		do
			Result := jorb.get_short_field (java_object_id, fid)
		end

	long_attribute (fid: POINTER): INTEGER_64
			-- Access to a 'long' attribute, returns a INTEGER_64
		do
			Result := jorb.get_long_field (java_object_id, fid)
		end

feature -- Attributes setting

	set_integer_attribute (fid: POINTER; value: INTEGER)
			-- Set an 'integer' attribute to 'value'
		do
			jorb.set_integer_field (java_object_id, fid, value)
		end

	set_string_attribute (fid: POINTER; value: STRING)
			-- Set a 'String' attribute to 'value'
		do
			jorb.set_string_field (java_object_id, fid, value)
		end

	set_object_attribute (fid: POINTER; value: OBSOLETE_JAVA_OBJECT)
			-- Set a java object attribute to 'value'
		do
			jorb.set_object_field (java_object_id, fid, value.java_object_id)
		end

	set_boolean_attribute (fid: POINTER; value: BOOLEAN)
			-- Set a 'boolean' attribute to 'value'
		do
			jorb.set_boolean_field (java_object_id, fid, value)
		end

	set_char_attribute (fid: POINTER; value: CHARACTER)
			-- Set a 'char' attribute to 'value'
		do
			jorb.set_char_field (java_object_id, fid, value)
		end

	set_float_attribute (fid: POINTER; value: REAL)
			-- Set a 'float' attribute to 'value'
		do
			jorb.set_float_field (java_object_id, fid, value)
		end

	set_double_attribute (fid: POINTER; value: DOUBLE)
			-- Set a 'double' attribute to 'value'
		do
			jorb.set_double_field (java_object_id, fid, value)
		end

	set_byte_attribute (fid: POINTER; value: INTEGER_8)
			-- Set a 'byte' attribute to 'value'
		do
			jorb.set_byte_field (java_object_id, fid, value)
		end

	set_short_attribute (fid: POINTER; value: INTEGER_16)
			-- Set a 'short' attribute to 'value'
		do
			jorb.set_short_field (java_object_id, fid, value)
		end

	set_long_attribute (fid: POINTER; value: INTEGER_64)
			-- Set a 'short' attribute to 'value'
		do
			jorb.set_long_field (java_object_id, fid, value)
		end

end -- class JAVA_OBJECT_REFERENCE
