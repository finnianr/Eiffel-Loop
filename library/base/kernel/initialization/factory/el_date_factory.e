note
	description: "Factory to create items conforming to ${DATE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	EL_DATE_FACTORY [G -> DATE create make_by_days end]

inherit
	EL_FACTORY [G]

feature -- Access

	new_item: G
		do
			create Result.make_by_days (0)
		end

end