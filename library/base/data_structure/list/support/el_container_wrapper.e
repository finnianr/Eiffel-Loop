note
	description: "Createable version of class ${EL_CONTAINER_STRUCTURE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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