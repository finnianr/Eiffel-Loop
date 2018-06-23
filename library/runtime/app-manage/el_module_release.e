note
	description: "Access to shared instance of [$source EL_OS_RELEASE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 10:09:47 GMT (Tuesday 5th June 2018)"
	revision: "2"

class
	EL_MODULE_RELEASE

feature -- Constants

	OS_release: EL_OS_RELEASE_I
		once
			create {EL_OS_RELEASE_IMP} Result.make
		end
end
