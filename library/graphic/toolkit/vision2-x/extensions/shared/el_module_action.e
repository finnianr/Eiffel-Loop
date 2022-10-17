note
	description: "Shared instance of [$source EL_ACTION_MANAGER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 18:29:55 GMT (Monday 17th October 2022)"
	revision: "13"

deferred class
	EL_MODULE_ACTION

inherit
	EL_MODULE

feature {NONE} -- Constants

	Action: EL_ACTION_MANAGER
			--
		once ("PROCESS")
			create Result
		end

end
