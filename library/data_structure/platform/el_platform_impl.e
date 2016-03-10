note
	description: "Platform dependent implementation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 10:11:05 GMT (Wednesday 24th June 2015)"
	revision: "2"

class
	EL_PLATFORM_IMPL

feature {NONE} -- Initialization

	make
		do
		end

feature -- Element change

	set_interface (a_interface: like interface)
		do
			interface := a_interface
		end

feature {NONE} -- Implementation

	interface: ANY

end
