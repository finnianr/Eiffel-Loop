note
	description: "Interface to Java primitive: `int'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	J_INT

inherit
	JAVA_PRIMITIVE_TYPE [INTEGER]

create
	default_create,	make,
	make_from_integer, make_from_java_method_result, make_from_java_attribute

convert
	make_from_integer ({INTEGER})

feature {NONE} -- Initialization

	make_from_integer (a_value: INTEGER)
			--
		do
			make
			value := a_value
		end

	make_from_java_method_result (target: JAVA_OBJECT_REFERENCE; a_method_id: POINTER; args: JAVA_ARGUMENTS)
			--
		do
			make
			value := jni.call_int_method (target.java_object_id, a_method_id, args.to_c)
		end

	make_from_java_attribute (target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER)
			--
		do
			make
			value := target.integer_attribute (a_field_id)
		end

feature {NONE, JAVA_FUNCTION} -- Implementation

	set_argument (argument: JAVA_VALUE)
			--
		do
			argument.set_int_value (value)
		end

	Jni_type_signature: STRING = "I"

end