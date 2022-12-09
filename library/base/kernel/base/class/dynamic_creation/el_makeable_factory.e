note
	description: "A factory cell to create objects conforming to [$source EL_MAKEABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-07 9:13:26 GMT (Wednesday 7th December 2022)"
	revision: "3"

class
	EL_MAKEABLE_FACTORY [G-> EL_MAKEABLE create make end]

inherit
	EL_FACTORY [G]

feature -- Access

	new_item: G
		do
			create Result.make
		end
end