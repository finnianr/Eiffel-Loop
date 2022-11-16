note
	description: "Java constructor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	JAVA_CONSTRUCTOR

inherit
	JAVA_ROUTINE
		rename
			method_id as constructor_id,
			make as make_routine
		export
			{JAVA_OBJECT_OR_CLASS} constructor_id, java_args
		end

	JAVA_SHARED_ORB

create
	make

feature {NONE} -- Initialization

	make (wrapper_routine: ROUTINE)
			--
		do
			make_routine ("<init>", wrapper_routine)
		end

feature -- Access

	java_object_id (target: JAVA_OBJECT_REFERENCE; args: TUPLE): POINTER
			--
		do
			java_args.put_java_tuple (args)
			Result := jorb.new_object (target.jclass.java_class_id, constructor_id, java_args.to_c)
		end

feature {NONE} -- Implementation

	return_type_signature: STRING
			-- Routines return type void
		local
			c: EL_STRING_8_ROUTINES
		do
			Result := c.character_string ('V')
		end

end