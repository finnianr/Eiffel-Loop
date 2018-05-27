note
	description: "Module win registry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_MODULE_WIN_REGISTRY

inherit
	EL_MODULE

feature -- Access

	Win_registry: EL_WINDOWS_REGISTRY_ROUTINES
		once
			create Result
		end
end
