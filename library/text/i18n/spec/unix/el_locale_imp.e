note
	description: "Unix implementation of `EL_LOCALE_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-18 10:40:36 GMT (Saturday 18th November 2017)"
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
			Result := Execution.item ("LANG").split ('_').first
		end

end
