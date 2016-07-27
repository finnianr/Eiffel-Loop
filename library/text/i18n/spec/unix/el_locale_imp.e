note
	description: "Unix implementation of `EL_LOCALE_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 21:23:50 GMT (Thursday 7th July 2016)"
	revision: "4"

class
	EL_LOCALE_IMP

inherit
	EL_LOCALE_I

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_OS_IMPLEMENTATION

create
	make

feature -- Access

	user_language_code: STRING
			-- By example: if LANG = "en_UK.utf-8"
			-- then result = "en"
		do
			Result := Execution.get ("LANG").split ('_').first
		end

end