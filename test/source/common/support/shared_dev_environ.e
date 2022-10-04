note
	description: "Shared instance of [$source DEVELOPMENT_ENVIRONMENT]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 9:08:08 GMT (Tuesday 4th October 2022)"
	revision: "1"

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