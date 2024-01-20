note
	description: "[
		Object to save and restore cursor position or index of a ${TRAVERSABLE} container
	}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

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
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "2"

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