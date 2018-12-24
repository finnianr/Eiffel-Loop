note
	description: "Rich text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:35:35 GMT (Friday 21st December 2018)"
	revision: "6"

class
	EL_RICH_TEXT
inherit
	EV_RICH_TEXT
		redefine
			create_implementation, implementation
		end

feature {NONE} -- Implementation

	create_implementation
			--
		do
			create {EL_RICH_TEXT_IMP} implementation.make
		end

	implementation: EL_RICH_TEXT_I

end