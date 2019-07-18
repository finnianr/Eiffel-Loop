note
	description: "Module machine id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:58:53 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_MODULE_MACHINE_ID

inherit
	EL_MODULE

feature {NONE} -- Constants

	Machine_id: EL_UNIQUE_MACHINE_ID
		once
			create Result.make
		end

end
