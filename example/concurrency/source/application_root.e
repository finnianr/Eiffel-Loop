note
	description: "[
		Root for two concurrency demonstrations:
		
		1. [$source HORSE_RACE_APP]
		2. [$source SINE_WAVE_INTEGRATION_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-29 8:10:20 GMT (Saturday 29th April 2023)"
	revision: "63"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		HORSE_RACE_APP,
		SINE_WAVE_INTEGRATION_APP
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_LOGGED_FUNCTION_DISTRIBUTER [ANY], EL_LOGGED_PROCEDURE_DISTRIBUTER [ANY]]
		do
			create Result
		end

end