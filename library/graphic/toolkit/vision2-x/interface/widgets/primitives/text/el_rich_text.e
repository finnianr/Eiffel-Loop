note
	description: "Summary description for {EL_RICH_TEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
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