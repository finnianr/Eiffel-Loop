note
	description: "Platform dependent implementation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 6:50:09 GMT (Friday 24th June 2016)"
	revision: "3"

class
	EL_PLATFORM_IMPLEMENTATION

feature {EL_CROSS_PLATFORM} -- Initialization

	make
		require
			interface_set: attached interface
			-- This implies the instance must be created first with `default_create'
			-- and then `set_interface' called. See class `EL_CROSS_PLATFORM'
		do
		end

feature -- Element change

	set_interface (a_interface: like interface)
		do
			interface := a_interface
		end

feature {EL_CROSS_PLATFORM} -- Implementation

	interface: ANY

end
