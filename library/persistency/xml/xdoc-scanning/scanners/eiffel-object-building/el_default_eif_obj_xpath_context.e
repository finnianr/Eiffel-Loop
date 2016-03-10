note
	description: "Summary description for {EL_DEFAULT_EIF_OBJ_XPATH_CONTEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 15:38:09 GMT (Thursday 1st January 2015)"
	revision: "6"

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
