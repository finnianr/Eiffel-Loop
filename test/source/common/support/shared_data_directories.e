note
	description: "Shared instance of ${DATA_DIRECTORIES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 17:10:00 GMT (Sunday 4th May 2025)"
	revision: "1"

deferred class
	SHARED_DATA_DIRECTORIES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Data_dir: DATA_DIRECTORIES
		once
			create Result.make_english
		end
end