note
	description: "Platform dependent implementation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

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