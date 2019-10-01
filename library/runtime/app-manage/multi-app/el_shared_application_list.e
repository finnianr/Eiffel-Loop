note
	description: "Shared instance of [$source EL_SUB_APPLICATION_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 11:48:52 GMT (Tuesday   1st   October   2019)"
	revision: "6"

deferred class
	EL_SHARED_APPLICATION_LIST

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application_list: EL_SUB_APPLICATION_LIST
		local
			s: EL_SINGLETON [EL_SUB_APPLICATION_LIST]
		once ("PROCESS")
			create s
			Result := s.singleton
		end

end
