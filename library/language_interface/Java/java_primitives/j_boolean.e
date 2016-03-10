note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	J_BOOLEAN

inherit
	JAVA_PRIMITIVE_TYPE [BOOLEAN]

create
	default_create,
	make, make_from_boolean,
	make_from_java_method_result,
	make_from_java_attribute

convert
	make_from_boolean ({BOOLEAN})

feature {NONE} -- Initialization

	make_from_boolean (bool: BOOLEAN)
			--
		do
			make
			value := bool
		end

	make_from_java_method_result (
		target: JAVA_OBJECT_REFERENCE;
		a_method_id: POINTER;
		args: JAVA_ARGUMENTS
	)
			--
		do
			make
			value := jni.call_boolean_method (target.java_object_id, a_method_id, args.to_c)
		end

	make_from_java_attribute (
		target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER
	)
			--
		do
			make
			value := target.boolean_attribute (a_field_id)
		end

feature {NONE, JAVA_FUNCTION} -- Implementation

	set_argument (argument: JAVA_VALUE)
			--
		do
			argument.set_boolean_value (value)
		end

	Jni_type_signature: STRING = "Z"

end -- class J_BOOLEAN
