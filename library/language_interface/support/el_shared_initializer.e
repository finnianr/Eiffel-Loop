note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

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
