note
	description: "Shared instance of ${EL_FACTORY_ROUTINES_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-03 17:45:42 GMT (Tuesday 3rd September 2024)"
	revision: "3"

deferred class
	EL_MODULE_FACTORY

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Factory: EL_FACTORY_ROUTINES_IMP
		once
			create Result
		end
end