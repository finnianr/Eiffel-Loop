note
	description: "[
		Object to save and restore cursor position or index of a [$source TRAVERSABLE} container
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-16 10:39:48 GMT (Sunday 16th October 2022)"
	revision: "4"

class
	EL_SAVED_CURSOR [G]

inherit
	EL_CONTAINER_WRAPPER [G]
		export
			{NONE} all
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_container: CONTAINER [G])
		do
			Precursor (a_container)
			push_cursor
		end

feature -- Basic operations

	restore
		do
			pop_cursor
		end

end