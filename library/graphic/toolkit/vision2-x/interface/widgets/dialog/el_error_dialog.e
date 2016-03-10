note
	description: "Summary description for {EL_ERROR_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_ERROR_DIALOG

inherit
	EV_DIALOG

feature {NONE} -- Initialization

	make (a_title, a_message: EL_ASTRING)
		deferred
		end

end
