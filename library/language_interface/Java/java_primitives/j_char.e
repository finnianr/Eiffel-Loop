note
	description: "Summary description for {J_CHAR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-09-07 19:48:37 GMT (Wednesday 7th September 2011)"
	revision: "1"

class
	J_CHAR

inherit
	JAVA_PRIMITIVE_TYPE [CHARACTER]

create
	default_create,	make,
	make_from_character, make_from_java_method_result, make_from_java_attribute

convert
	make_from_character ({CHARACTER})

feature {NONE} -- Initialization

	make_from_character (a_value: CHARACTER)
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
			value := jni.call_char_method (target.java_object_id, a_method_id, args.to_c)
		end

	make_from_java_attribute (
		target: JAVA_OBJECT_OR_CLASS; a_field_id: POINTER
	)
			--
		do
			make
			value := target.char_attribute (a_field_id)
		end

feature {NONE, JAVA_FUNCTION} -- Implementation

	set_argument (argument: JAVA_VALUE)
			--
		do
			argument.set_char_value (value)
		end

	Jni_type_signature: STRING = "C"

end
