note
	description: "[
		Restores playslist from /home/<user>/.local/share/rhythmbox/playlists.backup.xml
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-16 13:47:07 GMT (Monday 16th August 2021)"
	revision: "4"

class
	RESTORE_PLAYLISTS_TASK

inherit
	RBOX_MANAGEMENT_TASK

	DATABASE_UPDATE_TASK

	EL_MODULE_USER_INPUT

create
	make

feature -- Basic operations

	apply
			-- restore playlists from playlists.backup.xml
		local
			backup_path: EL_FILE_PATH
		do
			backup_path := Database.playlists_xml_path.with_new_extension ("backup.xml")
			if backup_path.exists then
				lio.put_line (Warning_prompt)
				if User_input.approved_action_y_n ("Are you sure?") then
					lio.put_path_field ("Restoring playlists from", backup_path)
					lio.put_new_line
					Database.playlists.restore_from (create {RBOX_PLAYLIST_ARRAY}.make (backup_path))
				end
  			else
				lio.put_path_field ("File not found", backup_path)
				lio.put_new_line
			end
		end

feature {NONE} -- Constants

	Warning_prompt: STRING = "[
		This application will rewrite the playlists using audio ids stored in playlists.backup.xml
	]"

end