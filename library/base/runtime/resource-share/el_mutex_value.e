note
	description: "Mutually exclusive thread access to an expanded value item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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