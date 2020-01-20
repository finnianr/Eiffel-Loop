note
	description: "Eros shared application options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 9:23:22 GMT (Monday 20th January 2020)"
	revision: "1"

deferred class
	EROS_SHARED_APPLICATION_OPTIONS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application_option: EROS_APPLICATION_OPTIONS
		once
			create Result.make
		end
end
