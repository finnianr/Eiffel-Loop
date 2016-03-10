note
	description: "Summary description for {EL_PAYPAL_NUMBERED_SUB_PARAMETER_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
