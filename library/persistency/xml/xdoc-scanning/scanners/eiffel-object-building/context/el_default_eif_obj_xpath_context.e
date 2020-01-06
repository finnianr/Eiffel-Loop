note
	description: "Default eif obj xpath context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_DEFAULT_EIF_OBJ_XPATH_CONTEXT

inherit
	EL_EIF_OBJ_XPATH_CONTEXT

feature -- Basic operations

	do_with_xpath
		require else
			never_called: False
		do
		end
end