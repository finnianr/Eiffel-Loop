note
	description: "Access to shared instance of [$source EL_WEL_WINDOWS_VERSION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_MODULE_WINDOWS_VERSION

feature {NONE} -- Constants

	Windows_version: EL_WEL_WINDOWS_VERSION
		once ("PROCESS")
			create Result
		end

end