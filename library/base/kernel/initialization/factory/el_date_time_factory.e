note
	description: "Factory to create items conforming to ${DATE_TIME}"
	notes: "[
		A factory to create an instance of this factory for a type conforming to ${DATE_TIME}
		is accessible via ${EL_SHARED_FACTORIES}.Date_time_factory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 14:52:58 GMT (Thursday 4th April 2024)"
	revision: "7"

class
	EL_DATE_TIME_FACTORY [G -> DATE_TIME create make_from_epoch end]

inherit
	EL_FACTORY [G]

feature -- Access

	new_item: G
		do
			create Result.make_from_epoch (0)
		end

end