note
	description: "A status code with value defined by `code_definition'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 10:48:45 GMT (Wednesday 6th December 2017)"
	revision: "1"

deferred class
	EL_STATUS_CODE_VALUE [N -> {NUMERIC, HASHABLE}]

inherit
	EL_MAKEABLE_FROM_STRING_8
		redefine
			is_equal
		end

feature {NONE} -- Initialization

	make (code_name: STRING_8)
		require else
			valid_name: code_definition.is_valid_code_name (code_name)
		do
			code := code_definition.code (code_name)
		end

	make_default
		do
		end

feature -- Access

	as_string: STRING
		do
			Result := code_definition.code_name (code)
		end

	code: N

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := code = other.code
		end

feature {NONE} -- Implementation

	code_definition: EL_STATUS_CODE_REFLECTION [N]
		deferred
		end
end
