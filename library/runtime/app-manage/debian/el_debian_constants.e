note
	description: "Debian constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-26 11:04:08 GMT (Tuesday 26th November 2019)"
	revision: "2"

class
	EL_DEBIAN_CONSTANTS

feature {NONE} -- Constants

	Bin: ZSTRING
		once
			Result := "bin"
		end

	Debian: ZSTRING
		once
			Result := "DEBIAN"
		end

	Field_package: ZSTRING
		once
			Result := "Package"
		end

	Control: ZSTRING
		once
			Result := "control"
		end
end
