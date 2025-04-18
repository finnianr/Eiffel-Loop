note
	description: "Createable version of class ${EL_CONTAINER_STRUCTURE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-18 7:27:10 GMT (Friday 18th April 2025)"
	revision: "7"

class
	EL_CONTAINER_WRAPPER [G]

inherit
	EL_CONTAINER_STRUCTURE [G]
		rename
			current_container as container
		redefine
			count, is_string_container, item_area, type_of_container
		end

create
	make

feature {NONE} -- Initialization

	make (a_container: CONTAINER [G])
		do
			container := a_container
			type := container_type (a_container)
			inspect type
				when Type_special, Type_string then
					if attached {TO_SPECIAL [G]} a_container as special and then attached {FINITE [G]} a_container as finite then
					-- Immutable strings do not conform to CONTAINER
						item_area := special.area
						count := finite.count
					end
			else
				count := container_count (a_container)
			end
		end

feature -- Measurement

	count: INTEGER

feature {NONE} -- Implementation

	type_of_container (a_container: CONTAINER [ANY]): NATURAL_8
		do
			Result := type
		end

	is_string_container: BOOLEAN
		do
			Result := type = Type_string
		end

feature {NONE} -- Internal attributes

	container: CONTAINER [G]

	item_area: detachable SPECIAL [G]

	type: NATURAL_8

end