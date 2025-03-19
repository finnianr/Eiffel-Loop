note
	description: "Shared instance of ${EVC_TOKEN_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:04:20 GMT (Tuesday 18th March 2025)"
	revision: "11"

deferred class
	EVC_SHARED_TOKEN_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Keyword tokens

	Token: EVC_TOKEN_ENUM
		once ("PROCESS")
			create Result.make
		end
end