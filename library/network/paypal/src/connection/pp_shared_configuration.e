note
	description: "Pp shared configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 17:41:34 GMT (Friday 4th October 2019)"
	revision: "3"

deferred class
	PP_SHARED_CONFIGURATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Configuration: PP_CONFIGURATION
		once ("PROCESS")
			Result := create {EL_SINGLETON [PP_CONFIGURATION]}
		end
end
