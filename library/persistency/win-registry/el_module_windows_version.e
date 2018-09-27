note
	description: "Access to shared instance of [$source EL_WEL_WINDOWS_VERSION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_MODULE_WINDOWS_VERSION

feature {NONE} -- Constants

	Windows_version: EL_WEL_WINDOWS_VERSION
		once ("PROCESS")
			create Result
		end

end
