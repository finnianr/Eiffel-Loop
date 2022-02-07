note
	description: "Shared access to first created instance of object conforming to [$source EL_APPLICATION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 10:12:33 GMT (Monday 7th February 2022)"
	revision: "6"

deferred class
	EL_SHARED_APPLICATION

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Application: EL_APPLICATION
		-- Currently running application
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_APPLICATION]}
		end
end