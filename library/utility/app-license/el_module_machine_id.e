note
	description: "Module machine id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "9"

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