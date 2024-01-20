note
	description: "Shared instance of ${EL_IMMUTABLE_8_MANAGER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SHARED_IMMUTABLE_8_MANAGER

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Immutable_8: EL_IMMUTABLE_8_MANAGER
		once
			create Result
		end

end