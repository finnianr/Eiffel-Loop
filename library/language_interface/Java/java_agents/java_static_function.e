note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "3"

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

	set_method_id (method_name: STRING; mapped_routine: ROUTINE)
			--
		do
			if attached {BASE_TYPE} mapped_routine.target as target then
				method_id := target.jclass.method_id (method_name, method_signature (mapped_routine.empty_operands))
			end
		end

end -- class JAVA_STATIC_FUNCTION