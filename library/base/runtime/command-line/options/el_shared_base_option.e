note
	description: "Shared base option"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 15:15:17 GMT (Saturday 5th February 2022)"
	revision: "2"

deferred class
	EL_SHARED_BASE_OPTION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	frozen Base_option: EL_BASE_COMMAND_OPTIONS
		once ("PROCESS")
			create Result.make
		end
end