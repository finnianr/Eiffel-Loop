note
	description: "[
		${EL_ARRAYED_LIST} that starts discarding items from the head once the capacity has been reached
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-31 14:47:35 GMT (Tuesday 31st October 2023)"
	revision: "1"

class
	EL_DISCARDING_ARRAYED_LIST [G]

inherit
	EL_ARRAYED_LIST [G]
		export
			{NONE} append_sequence
		redefine
			append, extend, put_front
		end

create
	make, make_default_filled, make_filled,
	make_from_for, make_from, make_from_if,
	make_joined, make_from_special, make_from_array,
	make_from_sub_list, make_from_tuple

feature -- Element change

	append (list: ITERABLE [G])
		local
			list_count, i, discard_count: INTEGER
		do
			list_count := Iterable.count (list)
			if list_count > capacity then
				discard_count := list_count - capacity
			end
			across list as any loop
				i := i + 1
				if i > discard_count then
					extend (any.item)
				end
			end
		end

	put_front (v: like item)
			-- Add `v' to the beginning.
			-- Do not move cursor.
		local
			old_index: INTEGER
		do
			if count + 1 = capacity then
				old_index := index
				finish; remove
				index := old_index
			end
			Precursor (v)
		end


	extend (v: like item)
		local
			old_index: INTEGER
		do
			if count + 1 = capacity then
				old_index := index
				start; remove
				index := old_index - 1
			end
			Precursor (v)
		end

end