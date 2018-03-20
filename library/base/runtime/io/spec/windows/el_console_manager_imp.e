note
	description: "Windows implementation of [$source EL_CONSOLE_MANAGER_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:01:54 GMT (Wednesday 21st February 2018)"
	revision: "4"

class
	EL_CONSOLE_MANAGER_IMP

inherit
	EL_CONSOLE_MANAGER_I

	EL_OS_IMPLEMENTATION

create
	make

feature -- Status query

	Is_highlighting_enabled: BOOLEAN = False
			-- Can terminal color highlighting sequences be output to console

end
