note
	description: "Interface to object with initialized state"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 14:52:43 GMT (Wednesday 29th January 2020)"
	revision: "2"

deferred class
	EL_INITIALIZEABLE

feature {NONE} -- Initialization

	make
		deferred
		end

feature -- Status query

	is_initialized: BOOLEAN
		-- `True' if current type is initialized
end
