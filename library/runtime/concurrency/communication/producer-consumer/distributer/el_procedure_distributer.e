note
	description: "[
		Descendant of [$source EL_WORK_DISTRIBUTER] specialized for procedures.
		`G' is the target type of the procedures you wish to execute. For an example on how to use see
		[$source WORK_DISTRIBUTER_TEST_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 15:30:15 GMT (Sunday 20th February 2022)"
	revision: "5"

class
	EL_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_WORK_DISTRIBUTER [PROCEDURE]
		rename
			collect as collect_procedures,
			collect_final as collect_final_procedures
		end

create
	make, make_threads

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