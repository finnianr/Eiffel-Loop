note
	description: "Summary description for {EL_PAYPAL_OPTION_VARIABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-31 15:50:34 GMT (Tuesday 31st March 2015)"
	revision: "5"

deferred class
	EL_PAYPAL_OPTION_SUB_PARAMETER_LIST

inherit
	EL_PAYPAL_SUB_PARAMETER_LIST

feature -- Element change

	value_extend (value: ASTRING)
		do
			extend (Var_value, value)
		end

end
