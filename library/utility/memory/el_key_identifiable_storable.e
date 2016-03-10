note
	description: "Summary description for {EL_KEY_IDENTIFIABLE_STORABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_KEY_IDENTIFIABLE_STORABLE

inherit
	EL_STORABLE

	EL_KEY_IDENTIFIABLE
		undefine
			is_equal
		end
end
