note
	description: "Unix implementation of [$source EL_CONSOLE_MANAGER_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_CONSOLE_MANAGER_IMP

inherit
	EL_CONSOLE_MANAGER_I

	EL_OS_IMPLEMENTATION

create
	make

feature -- Status query

	is_highlighting_enabled: BOOLEAN
			-- Can terminal color highlighting sequences be output to console
		do
			Result := not no_highlighting_word_option_exists
		end

end
