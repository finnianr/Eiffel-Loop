note
	description: "Shared instance of [$source EL_FACTORY_ROUTINES_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-30 6:38:04 GMT (Saturday 30th December 2023)"
	revision: "1"

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