note
	description: "Shared instance of [$source EL_SUB_APPLICATION_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 17:25:38 GMT (Friday   4th   October   2019)"
	revision: "7"

deferred class
	EL_SHARED_APPLICATION_LIST

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application_list: EL_SUB_APPLICATION_LIST
		once ("PROCESS")
			Result := create {EL_SINGLETON [EL_SUB_APPLICATION_LIST]}
		end

end
