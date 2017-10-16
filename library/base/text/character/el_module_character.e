note
	description: "Summary description for {EL_MODULE_CHARACTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_MODULE_CHARACTER

inherit
	EL_MODULE

feature -- Access

	Character: EL_CHARACTER_ROUTINES
			--
		once
			create Result
		end
end