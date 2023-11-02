note
	description: "Unix implementation of [$source PROJECT_LAUNCHER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-02 13:54:39 GMT (Thursday 2nd November 2023)"
	revision: "1"

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