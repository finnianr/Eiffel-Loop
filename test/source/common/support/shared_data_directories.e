note
	description: "Shared instance of ${DATA_DIRECTORIES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 5:54:08 GMT (Monday 5th May 2025)"
	revision: "2"

deferred class
	SHARED_DATA_DIRECTORIES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Data_dir: DATA_DIRECTORIES
		once
			create Result.make
		end
end