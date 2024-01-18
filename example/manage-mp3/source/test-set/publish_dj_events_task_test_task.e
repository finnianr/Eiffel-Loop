note
	description: "Test set for class ${PUBLISH_DJ_EVENTS_TASK}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-22 15:04:23 GMT (Tuesday 22nd August 2023)"
	revision: "9"

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
				log.put_labeled_string (page.item, raw_file_digest (WWW_output_dir + page.item).to_base_64_string)
				log.put_new_line
			end
		end

feature {NONE} -- Constants

	WWW_output_dir: DIR_PATH
		once
			Result := work_area_data_dir #+ "www"
		end

	Checksum: NATURAL = 2930151012

	Task_config: STRING = "[
		publish_dj_events:
			music_dir = "workarea/rhythmdb/Music"
			
			publish:
				html_template = "playlist.html.evol"; html_index_template = "playlist-index.html.evol"
				www_dir = "workarea/rhythmdb/www"; upload = False
				ftp_site:
					encrypted_url:
						"HVQPk8fnB04fXvnHdSsvfGjfu0FMt2N1QWbjiSDK+a4QI2aB4XY3QEUC3tfn6wMhiVZrUz4rP59JmXjfdIbktQ=="
					credential:
						salt:
							"QmOh7tMBAGEyOrOBgMU9BJoJJ1R/dr67"
						digest:
							"66i62a1zmjfTUvaSSFUFSL7teSuOejiJlAa+4lEmIj0="
			
				ftp_destination_dir = "compadrito-tango-playlists"
	]"
end