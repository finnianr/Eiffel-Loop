note
	description: "Shared access to instance of class conforming to [$source RBOX_DATABASE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-16 11:55:25 GMT (Thursday 16th April 2020)"
	revision: "4"

deferred class
	SHARED_DATABASE

inherit
	EL_ANY_SHARED

	EL_MODULE_EXCEPTION

feature {NONE} -- Constants

	Database: RBOX_DATABASE
		local
			conforming: EL_CONFORMING_SINGLETON [RBOX_DATABASE]
		once
			create conforming
			Result := conforming.singleton
		end
end
