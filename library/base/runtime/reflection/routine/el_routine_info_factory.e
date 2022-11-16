note
	description: "Routine info factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ROUTINE_INFO_FACTORY

feature {NONE} -- Factory

	new_routine_info (name: STRING; routine: ROUTINE): EL_ROUTINE_INFO
		local
			type: TYPE [ROUTINE]
		do
			type := routine.generating_type
			if attached {TYPE [PROCEDURE]} type as procedure_type then
				create {EL_PROCEDURE_INFO} Result.make (name, procedure_type)
				
			elseif attached {TYPE [FUNCTION [ANY]]} type as function_type then
				create {EL_FUNCTION_INFO} Result.make (name, function_type)
			end
		end

end