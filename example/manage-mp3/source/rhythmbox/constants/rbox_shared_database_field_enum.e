note
	description: "Shared instance of [$source RBOX_DATABASE_FIELD_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-08 12:28:13 GMT (Wednesday 8th April 2020)"
	revision: "1"

deferred class
	RBOX_SHARED_DATABASE_FIELD_ENUM

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	DB_field: RBOX_DATABASE_FIELD_ENUM
		once
			create Result.make
		end
end
