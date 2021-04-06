note
	description: "Mutually exclusive thread access to an expanded value item conforming to [$source NUMERIC]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 12:23:23 GMT (Tuesday 6th April 2021)"
	revision: "5"

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