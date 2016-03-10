note
	description: "Summary description for {EL_DEFAULT_CREATE_SYNCHRONIZED_REF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MUTEX_MAKEABLE_REFERENCE [G -> EL_MAKEABLE create make end]

inherit
	EL_MUTEX_REFERENCE [G]
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			make (create {G}.make)
		end
end
