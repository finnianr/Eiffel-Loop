note
	description: "Windows implementation of [$source EL_CONSOLE_MANAGER_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-26 9:40:36 GMT (Tuesday 26th October 2021)"
	revision: "6"

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

	is_utf_8_encoded: BOOLEAN
		do
			Result := code_page ~ Utf_8.code_page
		end

end