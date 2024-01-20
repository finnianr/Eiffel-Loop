note
	description: "Shared instance of object conforming to ${EL_SOFTWARE_VERSION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "2"

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