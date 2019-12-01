note
	description: "Debian constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-30 15:36:25 GMT (Saturday 30th November 2019)"
	revision: "3"

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

	Conffiles: ZSTRING
		once
			Result := "conffiles"
		end

	Control: ZSTRING
		once
			Result := "control"
		end

	Copyright: ZSTRING
		once
			Result := "copyright"
		end

end
