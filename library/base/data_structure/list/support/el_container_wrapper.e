note
	description: "Createable version of class ${EL_CONTAINER_STRUCTURE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 17:13:25 GMT (Saturday 5th October 2024)"
	revision: "5"

class
	EL_CONTAINER_WRAPPER [G]

inherit
	EL_CONTAINER_STRUCTURE [G]
		rename
			current_container as container
		redefine
			count, is_string_container, item_area
		end

create
	make

feature {NONE} -- Initialization

	make (a_container: CONTAINER [G])
		do
			container := a_container
			if attached {TO_SPECIAL [G]} a_container as array
				and then attached {FINITE [G]} a_container as finite
			then
			-- Immutable strings do not conform to CONTAINER
				is_string_container := attached {STRING_GENERAL} a_container
				item_area := array.area
				count := finite.count
			else
				count := container_count (a_container)
			end
		end

feature -- Measurement

	count: INTEGER

feature {NONE} -- Internal attributes

	container: CONTAINER [G]

	item_area: detachable SPECIAL [G]

	is_string_container: BOOLEAN

end