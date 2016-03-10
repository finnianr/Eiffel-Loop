note
	description: "Summary description for {EL_PAYPAL_OPTION_VARIABLE_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
