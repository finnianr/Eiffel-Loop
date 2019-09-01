note
	description: "Shared database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:12:58 GMT (Sunday 1st September 2019)"
	revision: "1"

deferred class
	SHARED_DATABASE

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	new_shared: EL_SINGLETON [RBOX_DATABASE]
		do
			create Result
		end

feature {NONE} -- Constants

	Database: RBOX_DATABASE
		once
			Result := new_shared.singleton
		end
end
