note
	description: "Default eif obj xpath context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

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