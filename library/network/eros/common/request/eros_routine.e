note
	description: "Eros routine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EROS_ROUTINE

inherit
	EL_ROUTINE_INFO
		rename
			make as make_info
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_routine: ROUTINE)
		do
			make_info (a_name, a_routine.generating_type)
			item := a_routine
			arguments := new_tuple_argument
			item.set_operands (arguments)
		end

feature -- Access

	arguments: TUPLE

	item: ROUTINE

feature -- Status query

	is_function: BOOLEAN
		do
			Result := attached {FUNCTION [ANY]} item
		end

	is_procedure: BOOLEAN
		do
			Result := attached {PROCEDURE} item
		end

feature -- Basic operations

	apply
		do
			item.apply
		end
end