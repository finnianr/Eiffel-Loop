note
	description: "Summary description for {EL_MODULE_DIGEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_DIGEST

inherit
	EL_MODULE

feature {NONE} -- Constants

	Digest: EL_DIGEST_ROUTINES
		once
			create Result
		end

end
