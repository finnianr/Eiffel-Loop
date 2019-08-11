note
	description: "Module unix signals"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-09 14:30:38 GMT (Friday 9th August 2019)"
	revision: "1"

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
