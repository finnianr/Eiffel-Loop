note
	description: "Factory for objects of type ${EL_REFLECTIVELY_SETTABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_REFLECTIVELY_SETTABLE_FACTORY [S -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	EL_FACTORY [S]

feature -- Access

	new_item: S
		do
			create Result.make_default
		end

end