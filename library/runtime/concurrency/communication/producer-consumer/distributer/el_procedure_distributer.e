note
	description: "[
		Descendant of `[$source EL_WORK_DISTRIBUTER]' specialized for procedures.
		`G' is the target type of the procedures you wish to execute. For an example on how to use see
		[$source `TEST_WORK_DISTRIBUTER_APP']
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-08 12:29:48 GMT (Sunday 8th October 2017)"
	revision: "2"

class
	EL_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_WORK_DISTRIBUTER [PROCEDURE]
		rename
			collect as collect_procedures,
			collect_final as collect_final_procedures
		end

create
	make

feature -- Basic operations

	collect (result_list: LIST [G])
		--  collect the list of procedure targets of type G from `applied' procedure list
		do
			restrict_access
				move (applied, result_list)
			end_restriction
		end

	collect_final (result_list: LIST [G])
		--  collect the final list of procedure targets of type G from `applied' procedure list
		-- (following call to `do_final')
		do
			move (final_applied, result_list)
		end

feature {NONE} -- Implementation

	move (procedures: like applied; result_list: LIST [G])
		do
			from procedures.start until procedures.after loop
				if attached {G} procedures.item.target as target then
					result_list.extend (target)
				end
				procedures.remove
			end
		end

end
