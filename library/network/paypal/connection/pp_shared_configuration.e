note
	description: "Paypal shared configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-15 12:00:33 GMT (Sunday 15th November 2020)"
	revision: "4"

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