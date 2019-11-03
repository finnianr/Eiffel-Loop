note
	description: "Debian constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 10:53:59 GMT (Wednesday 25th September 2019)"
	revision: "1"

class
	EL_DEBIAN_CONSTANTS

feature {NONE} -- Constants

	Field_package: ZSTRING
		once
			Result := "Package"
		end

	Control: ZSTRING
		once
			Result := "control"
		end
end
