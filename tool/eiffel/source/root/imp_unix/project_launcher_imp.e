note
	description: "Unix implementation of ${PROJECT_LAUNCHER_I}"

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
		local
			desktop: EL_XDG_DESKTOP; index, start_index, quote_index: INTEGER
		do
			create ecf_path
			create desktop.make (desktop_path)
			index := desktop.exec.substring_index (Estudio, 1)
			if index > 0 then
				start_index := index + Estudio.count + 1
				quote_index := desktop.exec.index_of ('"', start_index)
				if quote_index > 0 then
					ecf_path := desktop.path + desktop.exec.substring (start_index, quote_index - 1)
				end
			end
		end

end