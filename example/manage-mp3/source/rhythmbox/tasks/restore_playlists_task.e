note
	description: "[
		Restores playslist from /home/<user>/.local/share/rhythmbox/playlists.backup.xml
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RESTORE_PLAYLISTS_TASK

inherit
	RBOX_MANAGEMENT_TASK

	EL_MODULE_USER_INPUT

create
	make

feature -- Basic operations

	apply
			-- restore playlists from playlists.backup.xml
		local
			backup_path: EL_FILE_PATH; ok: BOOLEAN
		do
			backup_path := Database.playlists_xml_path.with_new_extension ("backup.xml")
			if backup_path.exists then
				lio.put_line (Warning_prompt)
				lio.put_string ("Are you sure (y/n)")
				ok := User_input.entered_letter ('y')
				lio.put_new_line
				if ok then
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
