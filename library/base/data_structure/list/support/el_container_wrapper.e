note
	description: "Createable version of class ${EL_CONTAINER_STRUCTURE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EL_CONTAINER_WRAPPER [G]

inherit
	EL_CONTAINER_STRUCTURE [G]
		rename
			current_count as count,
			current_container as container
		end

create
	make

feature {NONE} -- Initialization

	make (a_container: CONTAINER [G])
		do
			container := a_container
		end

feature {NONE} -- Internal attributes

	container: CONTAINER [G]
end