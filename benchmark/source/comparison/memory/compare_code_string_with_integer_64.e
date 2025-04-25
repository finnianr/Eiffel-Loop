note
	description: "[
		Compare memory foot print of ${EL_CODE_STRING} with ${INTEGER_64}
	]"
	notes: "[
		Finalized results (25th April 2025):

			EL_CODE_STRING :  96.0 bytes (100%)
			INTEGER_64     :   8.0 bytes (-91.7%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 13:12:10 GMT (Friday 25th April 2025)"
	revision: "1"

class
	COMPARE_CODE_STRING_WITH_INTEGER_64

inherit
	EL_BENCHMARK_COMPARISON

	FEATURE_CONSTANTS

	JSON_TEST_DATA

create
	make

feature -- Access

	Description: STRING = "Memory: EL_CODE_STRING VS INTEGER_64"

feature -- Basic operations

	execute
		local
			geo_info: EL_IP_ADDRESS_GEOGRAPHIC_INFO; asn_string: EL_CODE_STRING
			integer_64: INTEGER_64
		do
			create geo_info.make_from_json (JSON_eiffel_loop_ip)
			asn_string := geo_info.asn_

			compare_memory ("Compare asn_string with integer_64", << asn_string, integer_64 >>)
		end

end