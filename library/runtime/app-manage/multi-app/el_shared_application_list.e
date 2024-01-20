note
	description: "Shared instance of ${EL_APPLICATION_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

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