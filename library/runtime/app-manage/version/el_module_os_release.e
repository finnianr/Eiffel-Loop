note
	description: "Access to shared instance of ${EL_OS_RELEASE_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-17 15:40:55 GMT (Monday 17th November 2025)"
	revision: "7"

class
	EL_MODULE_OS_RELEASE

feature {NONE} -- Constants

	OS_release: EL_OS_RELEASE_I
		once
			create {EL_OS_RELEASE_IMP} Result.make
		end
end