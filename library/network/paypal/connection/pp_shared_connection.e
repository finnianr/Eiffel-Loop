note
	description: "Summary description for {SHARED_PAYPAL_CONNECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PP_SHARED_CONNECTION

inherit
	EL_SHARED_CELL [PP_NVP_API_CONNECTION]
		rename
			item as paypal
		end

feature {NONE} -- Implementation

	cell: CELL [PP_NVP_API_CONNECTION]
		once
			create Result.put (new_paypal_connection)
		end

	new_paypal_connection: like paypal
			-- Circular reference to be overridden
		do
			Result := paypal
		end

end
