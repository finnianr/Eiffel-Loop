note
	description: "[
		Compare three enumeration implementations conforming to ${EL_HTTP_CODE_DESCRIPTIONS}
	]"
	notes: "[
		Finalized results (28th April 2025):
		
			HTTP_STATUS_ENUM    : 21312.0 bytes (100%)
			HTTP_STATUS_TABLE   : 16848.0 bytes (-20.9%)
			EL_HTTP_STATUS_ENUM :  5376.0 bytes (-74.8%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 14:45:54 GMT (Monday 28th April 2025)"
	revision: "2"

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