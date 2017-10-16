note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	JAVA_PROCEDURE [BASE_TYPE -> JAVA_OBJECT_REFERENCE]

inherit
	JAVA_ROUTINE [BASE_TYPE]

create
	make

feature -- Basic operations

	call (target: BASE_TYPE; args: TUPLE)
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

end -- class JAVA_PROCEDURE