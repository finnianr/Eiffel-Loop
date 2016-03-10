note
	description: "Summary description for {J_BYTE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-09-07 19:50:25 GMT (Wednesday 7th September 2011)"
	revision: "1"

class
	J_BYTE

inherit
	JAVA_PRIMITIVE_TYPE [INTEGER_8]

create
	default_create,	make,
	make_from_integer_8, make_from_java_method_result, make_from_java_attribute

convert
	make_from_integer_8 ({INTEGER_8})

feature {NONE} -- Initialization

	make_from_integer_8 (a_value: INTEGER_8)
			--
		do
			make
			value := a_value
		end

	make_from_java_method_result (
		target: JAVA_OBJECT_REFERENCE;
		a_method_id: POINTER;
		args: JAVA_ARGUMENTS
	)
			--
		do
			make
			value := jni.call_byte_method (target.java_object_id, a_method_id, args.to_c)
		end

	make_from_java_attribute (
		target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER
	)
			--
		do
			make
			value := target.byte_attribute (a_field_id)
		end

feature {NONE, JAVA_FUNCTION} -- Implementation

	set_argument (argument: JAVA_VALUE)
			--
		do
			argument.set_byte_value (value)
		end

	Jni_type_signature: STRING = "B"

end
