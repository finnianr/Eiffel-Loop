note
	description: "Summary description for {RBOX_DATABASE_TRANSFORM_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 10:35:36 GMT (Friday 8th July 2016)"
	revision: "1"

deferred class
	RBOX_DATABASE_TRANSFORM_APP

inherit
	RBOX_APPLICATION

	EL_MODULE_USER_INPUT

feature -- Basic operations

	normal_run
			--
		local
			user_agreed: BOOLEAN
		do
			create_database
			if database.is_initialized then
				if is_test_mode then
					user_agreed := True
				else
					lio.put_string_field_to_max_length ("WARNING", Warning_prompt, Warning_prompt.count)
					lio.put_new_line

					lio.put_line ("Have you backed up your mp3 music collection and the files:")
					lio.put_string ("rhythmdb.xml ; playlists.xml found in " + User_config_dir.to_string + "? (y/n) ")

					user_agreed := User_input.entered_letter ('y')
					lio.put_new_line
				end
				if user_agreed then
					if config.is_dry_run then
						transform_database
					else
						backup_playlists
						transform_database
					end
				else
					lio.put_line ("User did not press 'y'.")
				end
			end
		end

	transform_database
			--
		deferred
		end

	backup_playlists
		do
			database.playlists.backup
		end

feature {NONE} -- Constants

	Warning_prompt: STRING
		deferred
		end

end