note
	description: "Java function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:56:24 GMT (Wednesday 10th March 2021)"
	revision: "6"

class
	JAVA_FUNCTION [RESULT_TYPE -> JAVA_TYPE create default_create, make_from_java_method_result end]

inherit
	JAVA_ROUTINE
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_method_name: STRING; mapped_function: FUNCTION [RESULT_TYPE])
		do
			Precursor (a_method_name, mapped_function)
		end

feature -- Access

	item (target: JAVA_OBJECT_REFERENCE; args: TUPLE): RESULT_TYPE
			--
		require
			valid_operands: valid_operands (args)
		do
			java_args.put_java_tuple (args)
			create Result.make_from_java_method_result (target, method_id, java_args)
		end

feature {NONE} -- Implementation

	return_type_signature: STRING
			-- Routines return type void
		local
			sample_result: RESULT_TYPE
		do
			create sample_result
			Result := sample_result.Jni_type_signature
		end

end