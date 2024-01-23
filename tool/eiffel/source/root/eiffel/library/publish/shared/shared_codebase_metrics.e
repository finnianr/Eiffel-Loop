note
	description: "Shared mutex protected instance of ${CODEBASE_METRICS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "7"

deferred class
	SHARED_CODEBASE_METRICS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Codebase_metrics: EL_MUTEX_REFERENCE [CODEBASE_METRICS]
		once ("PROCESS")
			create Result.make (create {CODEBASE_METRICS}.make)
		end
end