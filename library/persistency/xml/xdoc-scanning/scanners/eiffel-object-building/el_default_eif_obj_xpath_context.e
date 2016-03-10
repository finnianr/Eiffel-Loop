note
	description: "Summary description for {EL_DEFAULT_EIF_OBJ_XPATH_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
