note
	description: "Object with routines remotely callable via EROS protcol"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:07:13 GMT (Sunday 22nd September 2024)"
	revision: "5"

deferred class
	EROS_OBJECT

feature {NONE} -- Initialization

	make_default
		do
			routine_table := Routine_table_by_type.item (Current)
		end

feature {EROS_OBJECT} -- Factory

	new_routine_table: EL_HASH_TABLE [EROS_ROUTINE, STRING]
		local
			table: EL_HASH_TABLE [ROUTINE, STRING]; routine: EROS_ROUTINE
		do
			create table.make_assignments (routines)
			create Result.make (table.count)
			across table as r loop
				create routine.make (r.key, r.item)
				Result.extend (routine, r.key)
			end
		end

feature {NONE} -- Implementation

	routines: ARRAY [TUPLE [STRING, ROUTINE]]
		-- remotely accessible routines
		deferred
		end

feature {NONE} -- Internal attributes

	routine_table: EL_HASH_TABLE [EROS_ROUTINE, STRING]

feature {NONE} -- Constants

	Routine_table_by_type: EL_FUNCTION_RESULT_TABLE [EROS_OBJECT, EL_HASH_TABLE [EROS_ROUTINE, STRING]]
			--
		once
			create Result.make (17, agent {EROS_OBJECT}.new_routine_table)
		end

end