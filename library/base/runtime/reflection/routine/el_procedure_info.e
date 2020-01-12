note
	description: "Procedure info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 18:26:21 GMT (Sunday 12th January 2020)"
	revision: "1"

class
	EL_PROCEDURE_INFO

inherit
	EL_ROUTINE_INFO
		redefine
			type
		end

create
	make

feature -- Access

	type: TYPE [PROCEDURE]

	result_type: TYPE [ANY]
end
