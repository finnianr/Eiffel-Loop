note
	description: "Interface to object with initialized state"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-20 19:31:24 GMT (Wednesday 20th December 2023)"
	revision: "4"

deferred class
	EL_INITIALIZEABLE

inherit
	EL_MAKEABLE

feature -- Status query

	is_initialized: BOOLEAN
		-- `True' if current type is initialized
end