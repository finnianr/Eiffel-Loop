note
	description: "Factory to create any object that has the **default_create** make routine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 7:34:04 GMT (Thursday 8th December 2022)"
	revision: "4"

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