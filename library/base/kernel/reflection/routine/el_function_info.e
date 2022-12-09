note
	description: "Function info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_FUNCTION_INFO

inherit
	EL_ROUTINE_INFO
		redefine
			make, type
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_type: like type)
		do
			Precursor (a_name, a_type)
			result_type := a_type.generic_parameter_type (2)
		end

feature -- Access

	type: TYPE [FUNCTION [ANY]]

	result_type: TYPE [ANY]
end