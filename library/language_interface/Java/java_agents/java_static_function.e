note
	description: "Java static function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	JAVA_STATIC_FUNCTION [RESULT_TYPE -> JAVA_TYPE create  default_create, make_from_java_method_result end]

inherit
	JAVA_FUNCTION [RESULT_TYPE]
		redefine
			valid_target, item, set_method_id
		end

create
	make

feature -- Access

	item (target: JAVA_OBJECT_REFERENCE; args: TUPLE): RESULT_TYPE
			--
		do
			java_args.put_java_tuple (args)
			create Result.make_from_java_method_result (target.jclass, method_id, java_args)
		end

feature -- Status Report

	valid_target (target_class: JAVA_OBJECT_REFERENCE): BOOLEAN
			--
		do
			if attached {JAVA_CLASS_REFERENCE} target_class as target then
				Result := is_attached (target.java_class_id)
			end
		end

feature {NONE} -- Implementation

	set_method_id (target: JAVA_OBJECT_REFERENCE; argument_types: EL_TUPLE_TYPE_ARRAY)
			--
		do
			method_id := target.jclass.method_id (method_name, method_signature (argument_types))
		end

end