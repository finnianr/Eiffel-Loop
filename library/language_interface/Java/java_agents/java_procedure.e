note
	description: "Java procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:47:08 GMT (Wednesday 10th March 2021)"
	revision: "5"

class
	JAVA_PROCEDURE

inherit
	JAVA_ROUTINE

create
	make

feature -- Basic operations

	call (target: JAVA_OBJECT_REFERENCE; args: TUPLE)
			--
		require
			valid_operands: valid_operands (args)
			valid_target: valid_target (target)
		do
			java_args.put_java_tuple (args)
			target.void_method (method_id , java_args)
		end

feature {NONE} -- Implementation

	return_type_signature: STRING = "V"
			-- Routines return type void

end