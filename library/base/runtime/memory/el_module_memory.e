note
	description: "Access to shared instance of [$source MEMORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-04 11:53:44 GMT (Sunday 4th April 2021)"
	revision: "1"

deferred class
	EL_MODULE_MEMORY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Memory: MEMORY
		once
			create Result
		end

end