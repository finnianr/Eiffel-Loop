note
	description: "[
		Descendant of `EL_WORK_DISTRIBUTER' specialized for procedures.
		`G' is the target type of the procedures you wish to execute. For an example on how to use see
		[http://www.eiffel-loop.com/test/source/apps/test_work_distributer_app.html `TEST_WORK_DISTRIBUTER_APP']
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-03 13:27:27 GMT (Tuesday 3rd October 2017)"
	revision: "1"

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
		local
			l_applied: like applied.item
		do
			restrict_access (applied)
				l_applied := applied.item
				if not l_applied.is_empty then
					from l_applied.start until l_applied.after loop
						if attached {G} l_applied.item.target as target then
							result_list.extend (target)
						end
						l_applied.remove
					end
				end
			end_restriction (applied)
		end

	collect_final (result_list: LIST [G])
		--  collect the final list of procedure targets of type G from `applied' procedure list
		-- (following call to `do_final')
		do
			from final_applied.start until final_applied.after loop
				if attached {G} final_applied.item.target as target then
					result_list.extend (target)
				end
				final_applied.remove
			end
		end

end
