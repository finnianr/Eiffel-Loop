note
	description: "Summary description for {EL_PAYPAL_NUMBERED_SUB_PARAMETER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-31 16:05:07 GMT (Tuesday 31st March 2015)"
	revision: "5"

deferred class
	EL_PAYPAL_NUMBERED_SUB_PARAMETER_LIST

inherit
	EL_PAYPAL_SUB_PARAMETER_LIST
		rename
			make as make_sub_parameter_list
		undefine
			new_name
		end

	EL_PAYPAL_NUMBERED_VARIABLE_NAME_SEQUENCE
		undefine
			is_equal, copy
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_number: like number)
		do
			Precursor (a_number)
			make_sub_parameter_list
		end
end
