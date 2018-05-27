note
	description: "Module eiffel"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_MODULE_EIFFEL

inherit
	EL_MODULE

feature -- Access

	Eiffel: INTERNAL
			--
		once
			create Result
		end

end