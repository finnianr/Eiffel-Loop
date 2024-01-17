note
	description: "A factory cell to create objects conforming to ${EL_MAKEABLE_FROM_STRING [STRING_GENERAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-17 10:38:12 GMT (Wednesday 17th January 2024)"
	revision: "2"

class
	EL_MAKEABLE_FROM_STRING_FACTORY [
		G-> EL_MAKEABLE_FROM_STRING [STRING_GENERAL] create make_default, make_from_general end
	]

inherit
	EL_FACTORY [G]
		rename
			new_item as new_default_item
		end

feature -- Access

	new_item (str: STRING_GENERAL): G
		do
			create Result.make_from_general (str)
		end

	new_default_item: G
		do
			create Result.make_default
		end

end