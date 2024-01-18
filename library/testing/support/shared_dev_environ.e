note
	description: "Shared instance of ${DEVELOPMENT_ENVIRONMENT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-30 13:58:58 GMT (Monday 30th October 2023)"
	revision: "3"

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