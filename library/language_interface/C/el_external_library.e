note
	description: "External library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-27 15:56:48 GMT (Monday 27th January 2020)"
	revision: "5"

deferred class
	EL_EXTERNAL_LIBRARY [G -> EL_INITIALIZEABLE create make end]

inherit
	EL_SHARED_INITIALIZER [G]

feature {NONE}  -- Initialization

	initialize_library
		local
			l_item: like item
		do
			l_item := item
		end

end
