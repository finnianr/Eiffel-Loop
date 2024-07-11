note
	description: "Shared access to routines of class ${EL_GEOLOCATION_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 14:46:42 GMT (Thursday 11th July 2024)"
	revision: "1"

deferred class
	EL_MODULE_GEOLOCATION

inherit
	EL_MODULE

feature {NONE} -- Constants

	Geolocation: EL_GEOLOCATION_ROUTINES
			--
		once
			create Result
		end

end