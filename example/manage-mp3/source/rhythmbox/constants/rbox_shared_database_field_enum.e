note
	description: "Shared instance of ${RBOX_DATABASE_FIELD_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

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