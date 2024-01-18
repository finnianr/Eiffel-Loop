note
	description: "Shared instance of object conforming to ${EL_SOFTWARE_VERSION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-29 10:29:17 GMT (Wednesday 29th November 2023)"
	revision: "1"

deferred class
	EL_SHARED_SOFTWARE_VERSION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	frozen Software_version: EL_SOFTWARE_VERSION
		once
			create Result.make_build
		end
end