note
	description: "Summary description for {EL_DEFAULT_EIF_OBJ_XPATH_CONTEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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