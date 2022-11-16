note
	description: "Procedure info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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