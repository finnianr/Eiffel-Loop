note
	description: "Summary description for {EL_MODULE_HTML}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_HTML

inherit
	EL_MODULE

feature -- Access

	Html: EL_HTML_ROUTINES
			--
		once
			create Result
		end
end
