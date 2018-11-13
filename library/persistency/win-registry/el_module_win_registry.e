note
	description: "Module win registry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:10:29 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_WIN_REGISTRY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Win_registry: EL_WINDOWS_REGISTRY_ROUTINES
		once
			create Result
		end
end
