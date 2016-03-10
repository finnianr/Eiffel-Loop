note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-18 10:22:09 GMT (Tuesday 18th December 2012)"
	revision: "1"

class
	JAVA_STATIC_FUNCTION [
		BASE_TYPE -> JAVA_OBJECT_REFERENCE,
		RESULT_TYPE -> JAVA_TYPE create  default_create, make_from_java_method_result end
	]

inherit
	JAVA_FUNCTION [BASE_TYPE, RESULT_TYPE]
		redefine
			valid_target, item, set_method_id
		end

create
	make

feature -- Access

	item (target: BASE_TYPE; args: TUPLE): RESULT_TYPE
			--
		do
			java_args.put_java_tuple (args)
			create Result.make_from_java_method_result (target.jclass, method_id, java_args)
		end

feature -- Status Report

	valid_target (target_class: BASE_TYPE): BOOLEAN
			--
		do
			Result := attached {JAVA_CLASS_REFERENCE} target_class as target and then is_attached (target.java_class_id)
		end

feature {NONE} -- Implementation

	set_method_id (method_name: STRING; mapped_routine: ROUTINE [BASE_TYPE, TUPLE])
			--
		do
			if attached {BASE_TYPE} mapped_routine.target as target then
				method_id := target.jclass.method_id (method_name, method_signature (mapped_routine.empty_operands))
			end
		end

end -- class JAVA_STATIC_FUNCTION
