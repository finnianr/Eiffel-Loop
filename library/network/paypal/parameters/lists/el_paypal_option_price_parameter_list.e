note
	description: "Summary description for {EL_PAYPAL_OPTION_PRICE_VARIABLE_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_PAYPAL_OPTION_PRICE_PARAMETER_LIST

inherit
	EL_PAYPAL_PARAMETER_LIST

create
	make

feature {NONE} -- Constants

	Name_prefix: EL_ASTRING
		once
			Result := "L_OPTION?PRICE"
		end

end
