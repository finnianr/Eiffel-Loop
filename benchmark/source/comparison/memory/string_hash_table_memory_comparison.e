note
	description: "[
		Compare memory foot print of ${HASH_TABLE [STRING, STRING]} with ${EL_IMMUTABLE_STRING_8_TABLE}
	]"
	notes: "[
		Finalized results (25th April 2025):

			HASH_TABLE                  :  7024.0 bytes (100%)
			EL_IMMUTABLE_STRING_8_TABLE :  3120.0 bytes (-55.6%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 13:41:53 GMT (Friday 25th April 2025)"
	revision: "2"

class
	STRING_HASH_TABLE_MEMORY_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	FEATURE_CONSTANTS

create
	make

feature -- Access

	Description: STRING = "HASH_TABLE [STRING, STRING] VS EL_IMMUTABLE_STRING_8_TABLE"

feature -- Basic operations

	execute
		local
			standard_table: HASH_TABLE [STRING, STRING]
		do
			create standard_table.make_equal (Feature_expansion_table.count)
			across Feature_expansion_table as table loop
				standard_table.extend (table.item, table.key)
			end
			compare_memory ("HTTP status enumerations", << standard_table, Feature_expansion_table >>)
		end

end