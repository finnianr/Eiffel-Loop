note
	description: "A query condition to test if a container has an item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_CONTAINER_HAS_QUERY_CONDITION [G]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_container: like container)
		do
			container := a_container
		end

feature -- Status query

	met (item: G): BOOLEAN
		-- `True' if `container' has `item'
		do
			Result := container.has (item)
		end

feature {NONE} -- Implementation

	container: CONTAINER [G]

end