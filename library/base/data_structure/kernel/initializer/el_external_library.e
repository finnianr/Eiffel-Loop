note
	description: "External library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	EL_EXTERNAL_LIBRARY [G -> EL_INITIALIZEABLE create default_create end]

inherit
	EL_SHARED_INITIALIZER [G]
		rename
			initialize as initialize_library
		end

end