note
	description: "Initializeable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_INITIALIZEABLE

inherit
	DISPOSABLE
		rename
			dispose as uninitialize
		undefine
			default_create
		end

feature -- Access

	is_initialized: BOOLEAN
		
invariant
	initialized: is_initialized

end