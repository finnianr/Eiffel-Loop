note
	description: "Routine info factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 18:38:11 GMT (Sunday 12th January 2020)"
	revision: "1"

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
