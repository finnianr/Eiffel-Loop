note
	description: "Summary description for {EL_RICH_TEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-02 17:09:13 GMT (Saturday 2nd March 2013)"
	revision: "2"

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
