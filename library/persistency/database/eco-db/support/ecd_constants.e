note
	description: "Eco-DB constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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