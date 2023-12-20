note
	description: "Shared base option"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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