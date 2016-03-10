note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	JAVA_CONSTRUCTOR  [BASE_TYPE -> JAVA_OBJECT_REFERENCE]

inherit
	JAVA_ROUTINE [BASE_TYPE]
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

	make (wrapper_routine: ROUTINE [BASE_TYPE, TUPLE])
			--
		do
			make_routine ("<init>", wrapper_routine)
		end

feature -- Access

	java_object_id (target: BASE_TYPE; args: TUPLE): POINTER
			--
		do
			java_args.put_java_tuple (args)
			Result := jorb.new_object (target.jclass.java_class_id, constructor_id, java_args.to_c)
		end

feature {NONE} -- Implementation

	return_type_signature: STRING
			-- Routines return type void
		do
			Result := "V"
		end

end -- class JAVA_CONSTRUCTOR
