note
	description: "Shared instance of [$source EL_SUB_APPLICATION_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-18 16:33:23 GMT (Thursday 18th July 2019)"
	revision: "4"

deferred class
	EL_SHARED_APPLICATION_LIST

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application_list: EL_SUB_APPLICATION_LIST
		local
			l: EL_SINGLETON [EL_SUB_APPLICATION_LIST]
		once ("PROCESS")
			create l
			Result := l.singleton
		end

end
