note
	description: "Shared instance of [$source EL_SUB_APPLICATION_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-27 14:49:16 GMT (Sunday 27th May 2018)"
	revision: "1"

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
