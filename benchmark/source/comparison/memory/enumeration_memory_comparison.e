note
	description: "[
		Compare three enumeration implementations conforming to ${EL_HTTP_CODE_DESCRIPTIONS}
	]"
	notes: "[
		Finalized results (29th April 2025):
		
			HTTP_STATUS_ENUM    : 18272.0 bytes (100%)
			HTTP_STATUS_TABLE   : 15392.0 bytes (-15.8%)
			EL_HTTP_STATUS_ENUM :  5376.0 bytes (-70.6%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 11:12:08 GMT (Tuesday 29th April 2025)"
	revision: "3"

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

end