note
	description: "Java procedure"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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