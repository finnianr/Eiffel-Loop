note
	description: "A factory cell to create objects conforming to [$source EL_MAKEABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-16 19:06:03 GMT (Thursday 16th January 2020)"
	revision: "1"

class
	EL_MAKEABLE_CELL [G-> EL_MAKEABLE create make end]

feature -- Access

	new_item: G
		do
			create Result.make
		end
end
