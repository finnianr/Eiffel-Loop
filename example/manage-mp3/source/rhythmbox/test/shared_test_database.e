note
	description: "Shared test database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 15:58:59 GMT (Sunday 1st September 2019)"
	revision: "1"

deferred class
	SHARED_TEST_DATABASE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Database: RBOX_TEST_DATABASE
		local
			l: EL_SINGLETON [RBOX_TEST_DATABASE]
		once
			create l
			Result := l.singleton
		end
end
