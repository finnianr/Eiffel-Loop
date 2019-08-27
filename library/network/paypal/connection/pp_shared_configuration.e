note
	description: "Pp shared configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-27 10:51:59 GMT (Tuesday 27th August 2019)"
	revision: "1"

deferred class
	PP_SHARED_CONFIGURATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Configuration: PP_CONFIGURATION
		local
			l: EL_SINGLETON [PP_CONFIGURATION]
		once ("PROCESS")
			create l
			Result := l.singleton
		end
end
