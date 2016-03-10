note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-18 10:19:59 GMT (Tuesday 18th December 2012)"
	revision: "1"

class
	JAVA_STATIC_PROCEDURE [BASE_TYPE -> JAVA_OBJECT_REFERENCE]

inherit
	JAVA_PROCEDURE [BASE_TYPE]
		redefine
			valid_target, call, set_method_id
		end

create
	make

feature -- Basic operations

	call (target: BASE_TYPE; args: TUPLE)
			--
		do
			java_args.put_java_tuple (args)
			target.jclass.void_method (method_id , java_args)
		end

feature -- Status Report

	valid_target (target: BASE_TYPE): BOOLEAN
			--
		do
			Result := attached {JAVA_CLASS_REFERENCE} target.jclass as target_class and then is_attached (target_class.java_class_id)
		end

feature {NONE} -- Implementation

	set_method_id (method_name: STRING; mapped_routine: ROUTINE [BASE_TYPE, TUPLE])
			--
		do
			if attached {BASE_TYPE} mapped_routine.target as target then
				method_id := target.jclass.method_id (method_name, method_signature (mapped_routine.empty_operands))
			end
		end

end -- class JAVA_STATIC_PROCEDURE
