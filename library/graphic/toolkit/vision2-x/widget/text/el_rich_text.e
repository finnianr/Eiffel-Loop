note
	description: "Rich text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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