note
	description: "[
		Root for two concurrency demonstrations:
		
		1. ${HORSE_RACE_APP}
		2. ${SINE_WAVE_INTEGRATION_APP}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "64"

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