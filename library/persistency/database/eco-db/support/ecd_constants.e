note
	description: "Eco-DB constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-07 15:14:19 GMT (Monday 7th March 2022)"
	revision: "1"

deferred class
	ECD_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Closed_editions: INTEGER_8 = 3

	Closed_no_editions: INTEGER_8 = 4

	Closed_safe_store: INTEGER_8 = 1

	Closed_safe_store_failed: INTEGER_8 = 2

	Default_file_extension: ZSTRING
		once
			Result := "dat"
		end

	Editions_file_extension: ZSTRING
		once
			Result := "editions.dat"
		end

end