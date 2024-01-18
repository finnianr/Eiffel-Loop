note
	description: "Iteration cursor for ${EL_ARRAYED_INTERVAL_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-23 10:33:57 GMT (Wednesday 23rd August 2023)"
	revision: "3"

class
	EL_ARRAYED_INTERVALS_CURSOR

inherit
	ARRAYED_LIST_ITERATION_CURSOR [INTEGER]
		rename
			item as item_lower
		redefine
			item_lower
		end

create
	make

feature -- Access

	item: INTEGER_INTERVAL
		local
			i: INTEGER
		do
			i := area_index * 2
			if attached area as a then
				create Result.make (a [i], a [i + 1])
			end
		end

	item_compact: INTEGER_64
		local
			ir: EL_INTERVAL_ROUTINES; i: INTEGER
		do
			i := area_index * 2
			if attached area as a then
				Result := ir.compact (a [i], a [i + 1])
			end
		end

	item_lower: INTEGER
		do
			Result := area [area_index * 2]
		end

	item_upper: INTEGER
		do
			Result := area [area_index * 2 + 1]
		end

end