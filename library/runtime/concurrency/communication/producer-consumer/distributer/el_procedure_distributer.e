note
	description: "[
		Descendant of `EL_WORK_DISTRIBUTER' specialized for procedures.
		`G' is the target type of the procedures you wish to execute. For an example on how to use see
		[http://www.eiffel-loop.com/test/source/apps/test_work_distributer_app.html `TEST_WORK_DISTRIBUTER_APP']

		**Known issues**
		If you don't give sufficient work to the threads, the `do_final' call may hang.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-19 7:35:23 GMT (Friday 19th May 2017)"
	revision: "1"

class
	EL_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_WORK_DISTRIBUTER
		rename
			collect as collect_procedures,
			collect_final as collect_final_procedures
		redefine
			unassigned_routine
		end

create
	make

feature -- Basic operations

	collect (result_list: LIST [G])
		do
			restrict_access
				if not applied.is_empty then
					from applied.start until applied.after loop
						if attached {G} applied.item.target as target then
							result_list.extend (target)
						end
						applied.remove
					end
				end
			end_restriction
		end

	collect_final (result_list: LIST [G])
		do
			from final_applied.start until final_applied.after loop
				if attached {G} final_applied.item.target as target then
					result_list.extend (target)
				end
				final_applied.remove
			end
		end

feature {NONE} -- Implementation

	unassigned_routine: detachable PROCEDURE [ANY, TUPLE]
		-- routine that is not yet assigned to any thread for execution

end
