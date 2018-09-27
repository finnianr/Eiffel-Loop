note
	description: "Shared initializer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

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