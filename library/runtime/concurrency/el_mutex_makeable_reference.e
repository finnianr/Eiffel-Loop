note
	description: "Mutex for object conforming to [$source EL_MAKEABLE] and createable with call to `make'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 15:14:51 GMT (Saturday 6th March 2021)"
	revision: "6"

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