note
	description: "[
		Defines an **across** loop scope in which multiple strings can be borrowed from a shared pool
		and automatically returned when the loop exits after first and only iteration
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 16:31:53 GMT (Monday 6th November 2023)"
	revision: "4"

class
	EL_STRING_POOL_SCOPE [S -> STRING_GENERAL create make end]

inherit
	ITERABLE [S]

create
	make

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
			create loan_indices_pool.make (3, agent new_loan_indices)
		end

feature -- Access

	new_cursor: EL_STRING_POOL_SCOPE_CURSOR [S]
		do
			create Result.make (Current)
		end

feature {NONE} -- Implementation

	new_loan_indices: ARRAYED_LIST [INTEGER]
		do
			create Result.make (3)
		end

feature {EL_STRING_POOL_SCOPE_CURSOR} -- Internal attributes

	loan_indices_pool: EL_AGENT_FACTORY_POOL [like new_loan_indices]

	pool: EL_STRING_POOL [S]

end