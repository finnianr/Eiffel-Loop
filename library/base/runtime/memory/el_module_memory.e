note
	description: "Access to shared instance of ${MEMORY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_MODULE_MEMORY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Memory: MEMORY
		once
			create Result
		end

end