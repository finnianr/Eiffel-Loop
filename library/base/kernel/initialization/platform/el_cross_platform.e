note
	description: "Object that presents a cross platform interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:46:17 GMT (Sunday 5th November 2023)"
	revision: "7"

class
	EL_CROSS_PLATFORM [I -> EL_PLATFORM_IMPLEMENTATION create default_create end]

feature {NONE} -- Initialization

	make_default
			--
		do
			create implementation
			implementation.set_interface (Current)
			implementation.make
		end

feature {NONE} -- Implementation

	implementation: I

end