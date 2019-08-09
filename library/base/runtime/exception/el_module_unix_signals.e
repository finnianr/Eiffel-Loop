note
	description: "Summary description for {EL_SHARED_UNIX_SIGNALS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_MODULE_UNIX_SIGNALS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Unix_signals: EL_UNIX_SIGNALS
		once
			create Result
		end
end
