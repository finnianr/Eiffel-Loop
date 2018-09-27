note
	description: "Rich text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

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