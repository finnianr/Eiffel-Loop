note
	description: "Shared base option"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-31 8:45:13 GMT (Tuesday 31st December 2019)"
	revision: "1"

deferred class
	EL_SHARED_BASE_OPTION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Base_option: EL_BASE_COMMAND_OPTIONS
		once
			create Result.make
		end
end
