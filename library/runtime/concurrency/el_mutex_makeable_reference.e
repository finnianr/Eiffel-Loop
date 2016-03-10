note
	description: "Summary description for {EL_DEFAULT_CREATE_SYNCHRONIZED_REF}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:50:17 GMT (Sunday 10th May 2015)"
	revision: "2"

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
