note
	description: "Access to shared instance of [$source EL_OS_RELEASE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_MODULE_OS_RELEASE

feature {NONE} -- Constants

	OS_release: EL_OS_RELEASE_I
		once
			create {EL_OS_RELEASE_IMP} Result.make
		end
end