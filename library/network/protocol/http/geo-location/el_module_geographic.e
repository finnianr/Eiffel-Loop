note
	description: "Summary description for {EL_MODULE_IP_NUMBER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_MODULE_GEOGRAPHIC

inherit
	EL_MODULE

feature {NONE} -- Constants

	Geographic: EL_GEOGRAPHICAL_ROUTINES
		once
			create Result.make
		end
end
