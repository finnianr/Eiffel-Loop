note
	description: "Shared application option"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-31 8:48:57 GMT (Tuesday 31st December 2019)"
	revision: "1"

deferred class
	EL_SHARED_APPLICATION_OPTION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application_option: EL_APPLICATION_COMMAND_OPTIONS
		once
			create Result.make
		end
end
