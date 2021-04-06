note
	description: "Mutually exclusive thread access to an object initializeable by `default_create'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 11:54:17 GMT (Tuesday 6th April 2021)"
	revision: "5"

class
	EL_MUTEX_CREATEABLE_REFERENCE [G -> ANY create default_create end]

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
			make (create {G})
		end

end
