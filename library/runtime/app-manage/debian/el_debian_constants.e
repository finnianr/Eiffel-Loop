note
	description: "Debian constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-26 7:50:17 GMT (Monday 26th June 2023)"
	revision: "6"

deferred class
	EL_DEBIAN_CONSTANTS

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Field: TUPLE [architecture, package: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Architecture, Package")
		end

	Name: TUPLE [bin, conffiles, control, DEBIAN: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "bin, conffiles, control, DEBIAN")
		end

end