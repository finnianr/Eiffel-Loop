note
	description: "Shared mutex protected instance of ${CODEBASE_METRICS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-17 17:39:06 GMT (Sunday 17th September 2023)"
	revision: "6"

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