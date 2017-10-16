note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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