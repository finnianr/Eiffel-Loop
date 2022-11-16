note
	description: "Java static procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	JAVA_STATIC_PROCEDURE

inherit
	JAVA_PROCEDURE
		redefine
			valid_target, call, set_method_id
		end

create
	make

feature -- Basic operations

	call (target: JAVA_OBJECT_REFERENCE; args: TUPLE)
			--
		do
			java_args.put_java_tuple (args)
			target.jclass.void_method (method_id , java_args)
		end

feature -- Status Report

	valid_target (target: JAVA_OBJECT_REFERENCE): BOOLEAN
			--
		do
			if attached {JAVA_CLASS_REFERENCE} target.jclass as target_class then
				Result := is_attached (target_class.java_class_id)
			end
		end

feature {NONE} -- Implementation

	set_method_id (target: JAVA_OBJECT_REFERENCE; argument_types: EL_TUPLE_TYPE_ARRAY)
			--
		do
			method_id := target.jclass.method_id (method_name, method_signature (argument_types))
		end

end