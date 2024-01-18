note
	description: "[
		Artificial scope defined by an **across** loop in which strings can be borrowed from a pool
		See class ${EL_STRING_POOL_SCOPE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 9:08:31 GMT (Wednesday 8th November 2023)"
	revision: "6"

class
	EL_STRING_POOL_SCOPE_CURSOR [S -> STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]
		rename
			item as borrowed_item,
			forth as end_scope
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (scope: EL_STRING_POOL_SCOPE [S])
		do
			pool := scope.pool
			loan_indices_pool := scope.loan_indices_pool
			loan_indices := Default_loan_indices
		end

	make_default
		do
			create pool.make (0)
			make (create {EL_STRING_POOL_SCOPE [S]}.make (pool))
		end

feature -- Status query

	after: BOOLEAN

feature -- Access

	borrowed_item: S
		do
			Result := pool.borrowed_item (0)
			loan_indices.extend (pool.last_index)
		end

	filled_borrowed_item (general: READABLE_STRING_GENERAL): S
		do
			Result := pool.borrowed_item (general.count)
			loan_indices.extend (pool.last_index)
			Result.append (general)
		end

feature -- Cursor movement

	end_scope
		do
			after := True
			pool.free_list (loan_indices)
			loan_indices_pool.recycle (loan_indices)
		end

	start_scope
		do
			after := False
			loan_indices := loan_indices_pool.borrowed_item
		end

feature {NONE} -- Internal attributes

	loan_indices: ARRAYED_LIST [INTEGER]

	loan_indices_pool: EL_FACTORY_POOL [like loan_indices]

	pool: EL_STRING_POOL [S]

feature {NONE} -- Constants

	Default_loan_indices: ARRAYED_LIST [INTEGER]
		once
			create Result.make (0)
		end

end