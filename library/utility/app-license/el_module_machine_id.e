note
	description: "Summary description for {EL_MODULE_MACHINE_ID}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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