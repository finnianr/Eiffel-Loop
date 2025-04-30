note
	description: "[
		Compare three enumeration implementations conforming to ${EL_HTTP_CODE_DESCRIPTIONS}
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 12:18:18 GMT (Wednesday 30th April 2025)"
	revision: "4"

class
	ENUMERATION_MEMORY_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Three implementations of EL_HTTP_CODE_DESCRIPTIONS"

feature -- Basic operations

	execute
		do
			compare_memory ("HTTP status enumerations", <<
				create {EL_HTTP_STATUS_ENUM}.make, create {HTTP_STATUS_ENUM}.make, create {HTTP_STATUS_TABLE}.make_default
			>>)
		end

note
	notes: "[
		Finalized results (29th April 2025):

			HTTP_STATUS_ENUM    : 18272.0 bytes (100%)
			HTTP_STATUS_TABLE   : 15392.0 bytes (-15.8%)
			EL_HTTP_STATUS_ENUM :  5376.0 bytes (-70.6%)

		Finalized results (30th April 2025):
		(After reimplementation of ${EL_ENUMERATION} size is 16% smaller)

			HTTP_STATUS_TABLE   : 15392.0 bytes (100%)
			HTTP_STATUS_ENUM    :  9824.0 bytes (-36.2%)
			EL_HTTP_STATUS_ENUM :  5376.0 bytes (-65.1%)

	]"

end