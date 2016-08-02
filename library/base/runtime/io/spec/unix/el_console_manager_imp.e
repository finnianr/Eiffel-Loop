note
	description: "Unix implementation of `EL_CONSOLE_MANAGER_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 17:56:39 GMT (Friday 8th July 2016)"
	revision: "1"

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
			Result := not Args.word_option_exists ({EL_LOG_COMMAND_OPTIONS}.no_highlighting)
		end

end