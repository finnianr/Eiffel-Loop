note
	description: "Factory to create items conforming to [$source TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-23 13:31:15 GMT (Friday 23rd December 2022)"
	revision: "5"

class
	EL_TIME_FACTORY [G -> TIME create make_by_seconds end]

inherit
	EL_FACTORY [G]

feature -- Access

	new_item: G
		do
			create Result.make_by_seconds (0)
		end

end