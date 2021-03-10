note
	description: "Interface to Java primitive: `float'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 10:42:16 GMT (Wednesday 10th March 2021)"
	revision: "5"

class
	J_FLOAT

inherit
	JAVA_PRIMITIVE_TYPE [REAL]

create
	default_create,
	make,
	make_from_real,
	make_from_java_method_result,
	make_from_java_attribute

convert
	make_from_real ({REAL})

feature {NONE} -- Initialization

	make_from_real (r: REAL)
			--
		do
			value := r
		end

	make_from_java_method_result (target: JAVA_OBJECT_REFERENCE; a_method_id: POINTER; args: JAVA_ARGUMENTS)
			--
		do
			make
			value := jni.call_float_method (target.java_object_id, a_method_id, args.to_c)
		end

	make_from_java_attribute (target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER)
			--
		do
			make
			value := target.float_attribute (a_field_id)
		end

feature {NONE, JAVA_FUNCTION} -- Implementation

	set_argument (argument: JAVA_VALUE)
			--
		do
			argument.set_float_value (value)
		end

	Jni_type_signature: STRING = "F"

end