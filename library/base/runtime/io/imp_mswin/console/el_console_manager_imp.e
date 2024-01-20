note
	description: "Windows implementation of ${EL_CONSOLE_MANAGER_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	EL_CONSOLE_MANAGER_IMP

inherit
	EL_CONSOLE_MANAGER_I

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature -- Status query

	Is_highlighting_enabled: BOOLEAN = False
			-- Can terminal color highlighting sequences be output to console

	is_utf_8_encoded: BOOLEAN
		do
			Result := Encoding.code_page ~ Utf_8.code_page
		end

end