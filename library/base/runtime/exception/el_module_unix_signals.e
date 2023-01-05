note
	description: "Module Unix signals"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 11:29:08 GMT (Thursday 5th January 2023)"
	revision: "3"

deferred class
	EL_MODULE_UNIX_SIGNALS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Unix_signals: EL_UNIX_SIGNALS
		once
			create Result
		end
end