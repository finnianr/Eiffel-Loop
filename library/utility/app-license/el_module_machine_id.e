note
	description: "Module machine id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:10:18 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_MACHINE_ID

inherit
	EL_MODULE

feature {NONE} -- Constants

	Machine_id: EL_UNIQUE_MACHINE_ID
		once
			create Result.make
		end

end
