note
	description: "[
		Descendant of [$source EL_WORK_DISTRIBUTER] specialized for functions.
		`G' is the return type of functions you wish to execute. For an example on how to use see class
		[$source WORK_DISTRIBUTER_TEST_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-24 12:41:28 GMT (Wednesday 24th November 2021)"
	revision: "5"

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
		do
			restrict_access
				move (applied, result_list)
			end_restriction
		end

	collect_final (result_list: LIST [G])
		--  collect the final list of function results of type G from `applied' function list
		-- (following call to `do_final')
		do
			move (final_applied, result_list)
		end

feature -- Type definitions

	Result_type: G
		require
			never_called: False
		do
		end

feature {NONE} -- Implementation

	move (functions: like applied; result_list: LIST [G])
		do
			from functions.start until functions.after loop
				result_list.extend (functions.item.last_result)
				functions.remove
			end
		end
end