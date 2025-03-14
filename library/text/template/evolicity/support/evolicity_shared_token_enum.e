note
	description: "Shared instance of ${EVOLICITY_TOKEN_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-14 5:42:08 GMT (Friday 14th March 2025)"
	revision: "10"

deferred class
	EVOLICITY_SHARED_TOKEN_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Keyword tokens

	Token: EVOLICITY_TOKEN_ENUM
		once ("PROCESS")
			create Result.make
		end
end