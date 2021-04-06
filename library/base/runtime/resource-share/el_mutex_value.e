note
	description: "Mutually exclusive thread access to an expanded value item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 12:23:12 GMT (Tuesday 6th April 2021)"
	revision: "1"

class
	EL_MUTEX_VALUE [expanded G]

inherit
	MUTEX
		export
			{NONE} all
		end

create
	make

feature -- Element change

	set_item (v: like actual_item)
			--
		do
			lock
			actual_item := v
			unlock
		end

feature -- Access

	item: like actual_item
			--
		do
			lock
			Result := actual_item
			unlock
		end

feature {NONE} -- Internal attributes

	actual_item: G
end