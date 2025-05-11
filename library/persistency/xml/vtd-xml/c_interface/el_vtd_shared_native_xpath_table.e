note
	description: "Shared instance of ${EL_NATIVE_XPATH_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-11 9:41:35 GMT (Sunday 11th May 2025)"
	revision: "1"

deferred class
	EL_VTD_SHARED_NATIVE_XPATH_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Native_xpath_table: EL_NATIVE_XPATH_TABLE
		once
			create Result.make (19)
		end

end