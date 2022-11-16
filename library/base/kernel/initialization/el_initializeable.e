note
	description: "Interface to object with initialized state"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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