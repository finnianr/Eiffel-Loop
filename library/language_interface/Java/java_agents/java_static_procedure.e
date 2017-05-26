note
	description: "Objects that ..."

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-22 8:38:17 GMT (Monday 22nd May 2017)"
	revision: "2"

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

	set_method_id (method_name: STRING; mapped_routine: ROUTINE)
			--
		do
			if attached {BASE_TYPE} mapped_routine.target as target then
				method_id := target.jclass.method_id (method_name, method_signature (mapped_routine.empty_operands))
			end
		end

end -- class JAVA_STATIC_PROCEDURE