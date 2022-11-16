note
	description: "Mutually exclusive thread access to an object initializeable by `default_create'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

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