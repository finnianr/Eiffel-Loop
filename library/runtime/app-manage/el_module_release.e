note
	description: "Access to shared instance of [$source EL_OS_RELEASE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-08 12:32:51 GMT (Thursday 8th March 2018)"
	revision: "1"

class
	EL_MODULE_RELEASE

feature -- Constants

	OS_release: EL_OS_RELEASE_I
		once
			create {EL_OS_RELEASE} Result.make
		end
end
