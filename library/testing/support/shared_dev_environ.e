note
	description: "Shared instance of ${DEVELOPMENT_ENVIRONMENT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

deferred class
	SHARED_DEV_ENVIRON

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Dev_environ: DEVELOPMENT_ENVIRONMENT
		once
			create Result
		end
end