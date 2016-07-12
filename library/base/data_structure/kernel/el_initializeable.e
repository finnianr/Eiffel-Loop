note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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
