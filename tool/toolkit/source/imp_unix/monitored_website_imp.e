note
	description: "Unix implementation of ${MONITORED_WEBSITE_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-20 10:01:05 GMT (Saturday 20th May 2023)"
	revision: "1"

class
	MONITORED_WEBSITE_IMP

inherit
	MONITORED_WEBSITE_I

create
	make

feature {NONE} -- Build from XML

	set_terminal_command
		local
			desktop_ssh_path: FILE_PATH; desktop: EL_XDG_DESKTOP
		do
			desktop_ssh_path := node.to_expanded_file_path
			if desktop_ssh_path.exists then
				create desktop.make (desktop_ssh_path)
				terminal_command := desktop.exec
			end
		end

end