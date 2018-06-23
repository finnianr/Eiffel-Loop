note
	description: "Shared instance of [$source EL_SUB_APPLICATION_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:43:18 GMT (Tuesday 5th June 2018)"
	revision: "2"

class
	EL_SHARED_APPLICATION_LIST

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
