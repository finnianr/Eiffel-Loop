note
	description: "J long"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	J_LONG

inherit
	JAVA_PRIMITIVE_TYPE [INTEGER_64]

create
	default_create,	make,
	make_from_integer_64, make_from_java_method_result, make_from_java_attribute

convert
	make_from_integer_64 ({INTEGER_64})

feature {NONE} -- Initialization

	make_from_integer_64 (a_value: INTEGER_64)
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
			value := jni.call_long_method (target.java_object_id, a_method_id, args.to_c)
		end

	make_from_java_attribute (
		target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER
	)
			--
		do
			make
			value := target.long_attribute (a_field_id)
		end

feature {NONE, JAVA_FUNCTION} -- Implementation

	set_argument (argument: JAVA_VALUE)
			--
		do
			argument.set_long_value (value)
		end

	Jni_type_signature: STRING = "J"

end