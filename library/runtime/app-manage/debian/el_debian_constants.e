note
	description: "Debian constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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