note
	description: "Debian constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-05 14:15:51 GMT (Thursday 5th December 2019)"
	revision: "4"

deferred class
	EL_DEBIAN_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Bin: ZSTRING
		once
			Result := "bin"
		end

	Debian: ZSTRING
		once
			Result := "DEBIAN"
		end

	Field: TUPLE [architecture, package: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Architecture, Package")
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
