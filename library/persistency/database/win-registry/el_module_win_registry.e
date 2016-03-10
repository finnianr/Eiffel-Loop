note
	description: "Summary description for {EL_MODULE_WIN_REGISTRY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MODULE_WIN_REGISTRY

inherit
	EL_MODULE

feature -- Access

	Win_registry: EL_WINDOWS_REGISTRY_ROUTINES
		once
			create Result
		end
end
