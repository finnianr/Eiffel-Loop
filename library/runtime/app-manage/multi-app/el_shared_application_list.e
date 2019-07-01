note
	description: "Shared instance of [$source EL_SUB_APPLICATION_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:08:22 GMT (Friday 25th January 2019)"
	revision: "3"

deferred class
	EL_SHARED_APPLICATION_LIST

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	new_application_list: EL_SUB_APPLICATION_LIST
		do
			create Result.make_empty
		end

feature {NONE} -- Constants

	Application_list: EL_SUB_APPLICATION_LIST
		once ("PROCESS")
			Result := new_application_list
		end

end
