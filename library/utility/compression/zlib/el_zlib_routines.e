note
	description: "Expanded form of ${EL_ZLIB_ROUTINES_I} for local use in routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 14:14:32 GMT (Sunday 30th March 2025)"
	revision: "13"

expanded class
	EL_ZLIB_ROUTINES

inherit
	EL_ZLIB_ROUTINES_I
		export
			{ANY} all
			{NONE} new_compressed, new_decompressed, Code_table
		end

	EL_EXPANDED_ROUTINES

end