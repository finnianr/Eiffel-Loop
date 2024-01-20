note
	description: "Shared instance of ${EL_FACTORY_ROUTINES_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "2"

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