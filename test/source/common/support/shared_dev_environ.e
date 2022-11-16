note
	description: "Shared instance of [$source DEVELOPMENT_ENVIRONMENT]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

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