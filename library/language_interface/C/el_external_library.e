note
	description: "External library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 14:53:08 GMT (Wednesday 29th January 2020)"
	revision: "7"

deferred class
	EL_EXTERNAL_LIBRARY [G -> EL_INITIALIZEABLE create make end]

inherit
	EL_SHARED_INITIALIZER [G]
		rename
			item as library
		end

feature {NONE}  -- Initialization

	initialize_library
		local
			l_library: like library
		do
			l_library := library
		ensure
			initialized: library.is_initialized
		end

end
