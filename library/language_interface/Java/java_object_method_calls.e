note
	description: "Java object method calls"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 13:54:03 GMT (Wednesday 10th March 2021)"
	revision: "1"

deferred class
	JAVA_OBJECT_METHOD_CALLS

inherit
	JAVA_SHARED_ORB

feature {NONE} -- Calls

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
			argsp := args.to_c
			jorb.call_void_method (java_object_id, mid, argsp)
		end

	string_method (mid: POINTER; args: JAVA_ARGUMENTS): STRING
			-- Call an instance function that returns a STRING.
		local
			argsp: POINTER
		do
			argsp := args.to_c
			Result := jorb.call_string_method (java_object_id, mid, argsp)
		end

	integer_method (mid: POINTER; args: JAVA_ARGUMENTS): INTEGER
			-- Call an instance function that returns an INTEGER.
		local
			argsp: POINTER
		do
			argsp := args.to_c
			Result := jorb.call_int_method (java_object_id, mid, argsp)
		end

	short_method (mid: POINTER; args: JAVA_ARGUMENTS): INTEGER_16
			-- Call an instance function that returns a Short (in
			-- Eiffel we still return an INTEGER).
		local
			argsp: POINTER
		do
			argsp := args.to_c
			Result := jorb.call_short_method (java_object_id, mid, argsp)
		end

	long_method (mid: POINTER; args: JAVA_ARGUMENTS): INTEGER_64
			-- Call an instance function that returns an Long. This
			-- function is not implemented.
		local
			argsp: POINTER
		do
			argsp := args.to_c
			Result := jorb.call_long_method (java_object_id, mid, argsp)
		end

	double_method (mid: POINTER; args: JAVA_ARGUMENTS): DOUBLE
			-- Call an instance function that returns a DOUBLE.
		local
			argsp: POINTER
		do
			argsp := args.to_c
			Result := jorb.call_double_method (java_object_id, mid, argsp)
		end

	float_method (mid: POINTER; args: JAVA_ARGUMENTS): REAL
			-- Call an instance function that returns a REAL.
		local
			argsp: POINTER
		do
			argsp := args.to_c
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

feature {NONE} -- Implementation

	java_object_id: POINTER
		-- Reference to java object.
		deferred
		end
end