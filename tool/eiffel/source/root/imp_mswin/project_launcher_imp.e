note
	description: "Windows (do nothing) implementation of ${PROJECT_LAUNCHER_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	PROJECT_LAUNCHER_IMP

inherit
	PROJECT_LAUNCHER_I

create
	make

feature {NONE} -- Initialization

	make (desktop_path: FILE_PATH)
		do
			create ecf_path
		end

end