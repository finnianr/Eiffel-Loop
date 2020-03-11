note
	description: "Module machine id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-09 10:18:00 GMT (Monday 9th March 2020)"
	revision: "8"

deferred class
	EL_MODULE_MACHINE_ID

inherit
	EL_MODULE

feature {NONE} -- Constants

	Machine_id: EL_UNIQUE_MACHINE_ID
		-- VyxPVBTmoka3ZBeARZ8uKA==
		once
			create Result.make
		end

end
