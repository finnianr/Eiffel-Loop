note
	description: "Function info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 18:44:49 GMT (Sunday 12th January 2020)"
	revision: "1"

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
