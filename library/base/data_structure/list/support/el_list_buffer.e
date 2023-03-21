note
	description: "A list buffer that is emptied each time it is accessed"
	notes: "Intended for sharing as a once routine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-21 19:17:30 GMT (Tuesday 21st March 2023)"
	revision: "1"

class
	EL_LIST_BUFFER [G -> ARRAYED_LIST [H] create make end, H]

create
	make

convert
	empty_item: {G}

feature {NONE} -- Initialization

	make
		do
			create item.make (0)
		end

feature -- Access

	empty_item: like item
		do
			Result := item
			Result.wipe_out
		ensure
			is_empty: Result.is_empty
		end

	item: G

end