note
	description: "Factory to create any object that has the **default_create** make routine"
	notes: "[
		A factory to create an instance of this factory for a type conforming to ${ANY}
		is accessible via ${EL_SHARED_FACTORIES}.Default_factory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 14:53:49 GMT (Thursday 4th April 2024)"
	revision: "5"

class
	EL_DEFAULT_CREATE_FACTORY [G -> ANY create default_create end]

inherit
	EL_FACTORY [G]

feature -- Access

	new_item: G
		do
			create Result.default_create
		end

end