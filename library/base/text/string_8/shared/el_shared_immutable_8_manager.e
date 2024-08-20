note
	description: "Shared instance of ${EL_IMMUTABLE_8_MANAGER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:57:55 GMT (Tuesday 20th August 2024)"
	revision: "4"

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