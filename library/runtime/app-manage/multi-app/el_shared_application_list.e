note
	description: "Shared instance of [$source EL_APPLICATION_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 16:15:54 GMT (Saturday 5th February 2022)"
	revision: "8"

deferred class
	EL_SHARED_APPLICATION_LIST

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application_list: EL_APPLICATION_LIST
		once ("PROCESS")
			Result := create {EL_SINGLETON [EL_APPLICATION_LIST]}
		end

end
