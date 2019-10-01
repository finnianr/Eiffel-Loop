note
	description: "Pp shared configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 11:48:52 GMT (Tuesday   1st   October   2019)"
	revision: "2"

deferred class
	PP_SHARED_CONFIGURATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Configuration: PP_CONFIGURATION
		local
			s: EL_SINGLETON [PP_CONFIGURATION]
		once ("PROCESS")
			create s
			Result := s.singleton
		end
end
