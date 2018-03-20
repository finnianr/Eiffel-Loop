note
	description: "Access to shared instance of [$source EL_WEL_WINDOWS_VERSION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-11 12:47:21 GMT (Sunday 11th March 2018)"
	revision: "2"

class
	EL_MODULE_WINDOWS_VERSION

feature {NONE} -- Constants

	Windows_version: EL_WEL_WINDOWS_VERSION
		once ("PROCESS")
			create Result
		end

end
