note
	description: "External library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 17:35:09 GMT (Monday 25th December 2023)"
	revision: "9"

deferred class
	EL_EXTERNAL_LIBRARY [G -> EL_INITIALIZEABLE create make end]

inherit
	EL_SHARED_INITIALIZER [G]
		rename
			item as library
		end

feature {NONE}  -- Initialization

	initialize_library
		do
			if attached library then
				do_nothing
			end
		ensure
			initialized: library.is_initialized
		end

end