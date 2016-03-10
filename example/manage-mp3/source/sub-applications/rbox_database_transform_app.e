note
	description: "Summary description for {RBOX_DATABASE_TRANSFORM_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-08 9:57:40 GMT (Thursday 8th January 2015)"
	revision: "4"

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
					log_or_io.put_string_field_to_max_length ("WARNING", Warning_prompt, Warning_prompt.count)
					log_or_io.put_new_line

					log_or_io.put_line ("Have you backed up your mp3 music collection and the files:")
					log_or_io.put_string ("rhythmdb.xml ; playlists.xml found in " + User_config_dir.to_string + "? (y/n) ")

					user_agreed := User_input.entered_letter ('y')
					log_or_io.put_new_line
				end
				if user_agreed then
					if config.is_dry_run then
						transform_database
					else
						backup_playlists
						transform_database
					end
				else
					log_or_io.put_line ("User did not press 'y'.")
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
