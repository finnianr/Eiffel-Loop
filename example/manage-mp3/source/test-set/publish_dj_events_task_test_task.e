note
	description: "Test set for class [$source PUBLISH_DJ_EVENTS_TASK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-18 15:01:22 GMT (Monday 18th January 2021)"
	revision: "4"

class
	PUBLISH_DJ_EVENTS_TASK_TEST_TASK

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [PUBLISH_DJ_EVENTS_TASK]
		redefine
			do_task
		end

	EL_MODULE_DIGEST

feature {NONE} -- Implementation

	do_task

		do
			task.apply
			across << "2014-10-01 Belvedere.html", "index.html" >> as page loop
				log.put_labeled_string (page.item, file_digest (WWW_output_dir + page.item).to_base_64_string)
				log.put_new_line
			end
		end

feature {NONE} -- Constants

	WWW_output_dir: EL_DIR_PATH
		once
			Result := work_area_data_dir.joined_dir_path ("www")
		end

	Checksum: NATURAL = 4130425499

	Task_config: STRING = "[
		publish_dj_events:
			music_dir = "workarea/rhythmdb/Music"
			
			publish:
				html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
				www_dir = "workarea/rhythmdb/www"; upload = False
			
				ftp_url = "eiffel-loop.com"
				ftp_user_home = "/public/www"
				ftp_destination_dir = "compadrito-tango-playlists"
	]"
end