note
	description: "Routine reflective"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 9:26:11 GMT (Monday 13th January 2020)"
	revision: "1"

deferred class
	EL_ROUTINE_REFLECTIVE

feature {NONE} -- Initialization

	make_default
		do
			routine_table := Routine_table_by_type.item (Current)
		end

feature {EL_ROUTINE_REFLECTIVE} -- Factory

	new_routine_table: EL_HASH_TABLE [ROUTINE, STRING]
		do
			create Result.make (routines)
		end

feature {NONE} -- Implementation

	routines: ARRAY [TUPLE [STRING, ROUTINE]]
		deferred
		end

feature {NONE} -- Internal attributes

	routine_table: EL_HASH_TABLE [ROUTINE, STRING]

feature {NONE} -- Constants

	Routine_table_by_type: EL_FUNCTION_RESULT_TABLE [EL_ROUTINE_REFLECTIVE, EL_HASH_TABLE [ROUTINE, STRING]]
			--
		once
			create Result.make (17, agent {EL_ROUTINE_REFLECTIVE}.new_routine_table)
		end

end
