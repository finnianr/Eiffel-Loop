note
	description: "Summary description for {EL_SPLIT_STRING_LIST_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SPLIT_STRING_LIST_ITERATION_CURSOR [S -> STRING_GENERAL create make, make_empty end]

inherit
	ARRAYED_LIST_ITERATION_CURSOR [INTEGER_64]
		rename
			item as item_interval
		redefine
			target
		end

create
	make

feature -- Access

	item: S
		do
			Result := target.i_th (cursor_index)
		end

feature {TYPED_INDEXABLE_ITERATION_CURSOR} -- Access

	target: EL_SPLIT_STRING_LIST [S]

end
