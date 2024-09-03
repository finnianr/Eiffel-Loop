note
	description: "A factory cell to create objects conforming to ${EL_MAKEABLE}"
	notes: "[
		A factory to create an instance of this factory for a type conforming to ${EL_MAKEABLE}
		is accessible via ${EL_SHARED_FACTORIES}.Makeable_factory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 14:54:21 GMT (Thursday 4th April 2024)"
	revision: "5"

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