note
	description: "A factory cell to create objects conforming to [$source EL_EL_MAKEABLE_FROM_STRING [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-14 11:43:39 GMT (Wednesday 14th December 2022)"
	revision: "1"

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