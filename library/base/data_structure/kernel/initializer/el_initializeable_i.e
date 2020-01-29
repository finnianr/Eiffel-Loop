note
	description: "Interface to object with initialized state"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-28 9:51:47 GMT (Tuesday 28th January 2020)"
	revision: "1"

deferred class
	EL_INITIALIZEABLE_I

feature {NONE} -- Initialization

	make
		deferred
		end

feature -- Status query

	is_initialized: BOOLEAN
		-- `True' if current type is initialized
		deferred
		end
end
