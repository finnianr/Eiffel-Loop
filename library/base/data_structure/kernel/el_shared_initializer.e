note
	description: "Shared initializer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:03 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_SHARED_INITIALIZER [G -> EL_INITIALIZEABLE create default_create end]

feature {NONE} -- Implementation

	initialize
			--
		do
			internal.put (create {G})
		end

	internal: CELL [G]
			--
		deferred
		end

feature -- Access

	item: G
			--
		do
			Result := internal.item
		end

end