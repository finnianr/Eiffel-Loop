note
	description: "A factory cell to create objects conforming to ${EL_MAKEABLE_TO_SIZE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_MAKEABLE_TO_SIZE_FACTORY [G-> EL_MAKEABLE_TO_SIZE create make end]

inherit
	EL_FACTORY [G]
		rename
			new_item as new_empty_item
		end

feature -- Access

	new_empty_item: G
		do
			create Result.make (0)
		end

	new_item (n: INTEGER): G
		do
			create Result.make (n)
		end
end