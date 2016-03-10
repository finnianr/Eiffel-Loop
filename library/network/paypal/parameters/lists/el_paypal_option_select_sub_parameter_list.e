note
	description: "Summary description for {EL_PAYPAL_OPTION_SELECT_VARIABLE_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_PAYPAL_OPTION_SELECT_SUB_PARAMETER_LIST

inherit
	EL_PAYPAL_PARAMETER_LIST

create
	make

feature {NONE} -- Constants

	Name_prefix: EL_ASTRING
		once
			Result := "L_OPTION?SELECT"
		end
end
