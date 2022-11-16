note
	description: "Shared application option"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	SHARED_APPLICATION_OPTION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application_option: APPLICATION_COMMAND_OPTIONS
		once
			create Result.make
		end
end