note
	description: "Factory to create items conforming to ${DATE}"
	notes: "[
		A factory to create an instance of this factory for a type conforming to ${DATE}
		is accessible via ${EL_SHARED_FACTORIES}.Date_factory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 9:02:26 GMT (Thursday 4th April 2024)"
	revision: "7"

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