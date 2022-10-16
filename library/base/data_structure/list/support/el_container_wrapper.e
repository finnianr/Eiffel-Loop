note
	description: "Createable version of class [$source EL_CONTAINER_STRUCTURE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-16 10:40:43 GMT (Sunday 16th October 2022)"
	revision: "1"

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