note
	description: "Module machine id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MODULE_MACHINE_ID

inherit
	EL_MODULE

feature -- Constants

	Machine_id: EL_UNIQUE_MACHINE_ID
		once
			create Result.make
		end

end