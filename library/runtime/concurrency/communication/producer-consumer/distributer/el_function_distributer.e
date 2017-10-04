note
	description: "[
		Descendant of `EL_WORK_DISTRIBUTER' specialized for functions.
		`G' is the return type of functions you wish to execute. For an example on how to use see class
		[http://www.eiffel-loop.com/test/source/apps/test_work_distributer_app.html `TEST_WORK_DISTRIBUTER_APP']
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-03 13:26:43 GMT (Tuesday 3rd October 2017)"
	revision: "1"

class
	EL_FUNCTION_DISTRIBUTER [G]

inherit
	EL_WORK_DISTRIBUTER [FUNCTION [G]]
		rename
			collect as collect_functions,
			collect_final as collect_final_functions
		end

create
	make

feature -- Basic operations

	collect (result_list: LIST [G])
		--  collect the list of function results of type G from `applied' function list
		local
			l_applied: like applied.item
		do
			restrict_access (applied)
				l_applied := applied.item
				if not l_applied.is_empty then
					from l_applied.start until l_applied.after loop
						result_list.extend (l_applied.item.last_result)
						l_applied.remove
					end
				end
			end_restriction (applied)
		end

	collect_final (result_list: LIST [G])
		--  collect the final list of function results of type G from `applied' function list
		-- (following call to `do_final')
		do
			from final_applied.start until final_applied.after loop
				result_list.extend (final_applied.item.last_result)
				final_applied.remove
			end
		end

end
