note
	description: "Mutually exclusive thread access to an expanded value item conforming to ${NUMERIC}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_MUTEX_NUMERIC [expanded N -> NUMERIC]

inherit
	EL_MUTEX_VALUE [N]
		redefine
			actual_item
		end

create
	make

feature -- Element change

	add (v: like actual_item)
		do
			lock
			actual_item := actual_item + v
			unlock
		end

	subtract (v: like actual_item)
		do
			lock
			actual_item := actual_item - v
			unlock
		end

	increment
		do
			lock
			actual_item := actual_item + actual_item.one
			unlock
		end

	decrement
		do
			lock
			actual_item := actual_item - actual_item.one
			unlock
		end

feature {NONE} -- Implementation

	actual_item: N

end