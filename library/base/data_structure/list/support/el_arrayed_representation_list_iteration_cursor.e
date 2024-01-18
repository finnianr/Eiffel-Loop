note
	description: "Iteration cursor for ${EL_ARRAYED_REPRESENTATION_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-20 15:02:36 GMT (Monday 20th November 2023)"
	revision: "1"

class
	EL_ARRAYED_REPRESENTATION_LIST_ITERATION_CURSOR [R, N]

inherit
	ARRAYED_LIST_ITERATION_CURSOR [R]
		redefine
			make, item, target
		end

create
	make

feature {NONE} -- Creation

	make (t: like target)
		do
			Precursor (t)
			seed_area := t.seed_area
		end

feature -- Access

	item: R
		do
			Result := target.to_representation (seed_area [area_index])
		end

	seed_item: N
		do
			Result := seed_area [area_index]
		end

feature {TYPED_INDEXABLE_ITERATION_CURSOR} -- Access

	seed_area: SPECIAL [N]

	target: EL_ARRAYED_REPRESENTATION_LIST [R, N]

end