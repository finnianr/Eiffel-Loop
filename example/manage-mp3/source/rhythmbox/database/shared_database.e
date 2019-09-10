note
	description: "Shared database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-04 15:38:51 GMT (Wednesday 4th September 2019)"
	revision: "2"

deferred class
	SHARED_DATABASE

inherit
	EL_ANY_SHARED

	EL_MODULE_EXCEPTION

feature {NONE} -- Constants

	Database: RBOX_DATABASE
		once
			if attached {RBOX_DATABASE} Current as db then
				Result := db
			else
				Exception.raise_developer ("Attempt to initialize Database once variable from %S", [generator])
			end
		end
end
