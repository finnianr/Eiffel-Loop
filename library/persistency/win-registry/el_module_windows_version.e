note
	description: "Access to shared instance of ${EL_WEL_WINDOWS_VERSION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_MODULE_WINDOWS_VERSION

feature {NONE} -- Constants

	Windows_version: EL_WEL_WINDOWS_VERSION
		once ("PROCESS")
			create Result
		end

end