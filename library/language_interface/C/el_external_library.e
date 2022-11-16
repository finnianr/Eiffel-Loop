note
	description: "External library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

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