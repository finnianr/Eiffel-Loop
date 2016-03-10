note
	description: "Summary description for {EL_MODULE_MACHINE_ID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_MACHINE_ID

inherit
	EL_MODULE

feature -- Constants

	Machine_id: EL_UNIQUE_MACHINE_ID
		once
			create Result.make
		end

end
