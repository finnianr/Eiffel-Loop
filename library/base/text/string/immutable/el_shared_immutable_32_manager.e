note
	description: "Shared instance of ${EL_IMMUTABLE_32_MANAGER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-16 12:13:57 GMT (Thursday 16th February 2023)"
	revision: "1"

deferred class
	EL_SHARED_IMMUTABLE_32_MANAGER

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Immutable_32: EL_IMMUTABLE_32_MANAGER
		once
			create Result
		end

end