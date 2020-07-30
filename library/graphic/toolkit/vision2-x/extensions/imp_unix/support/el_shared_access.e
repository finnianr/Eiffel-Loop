note
	description: "Shared access to routines of [$source EL_ENVIRONMENT_IMP] to solve export visibility issues"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-29 10:19:19 GMT (Wednesday 29th July 2020)"
	revision: "1"

deferred class
	EL_SHARED_ACCESS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Access: EL_ENVIRONMENT_IMP
		once
			create Result.make
		end
end
