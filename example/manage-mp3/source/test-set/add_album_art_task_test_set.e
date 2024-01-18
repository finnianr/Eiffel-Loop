note
	description: "Test set for class ${ADD_ALBUM_ART_TASK}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	ADD_ALBUM_ART_TASK_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [ADD_ALBUM_ART_TASK]
		redefine
			do_task
		end

feature {NONE} -- Implementation

	do_task

		do
			task.apply
			log.enter ("update_pictures")
			task.update_pictures
			log.exit
			assert ("task.change_count = 0", task.change_count = 0)
			assert ("All song audio id match the file audio id",
				across database.existing_songs as song all
					mp3 (song.item.mp3_path).audio_id.to_delimited (':').is_equal (song.item.audio_id)
				end
			)
		end

	mp3 (mp3_path: FILE_PATH): EL_MP3_IDENTIFIER
		do
			create Result.make (mp3_path)
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 4142368163

	Task_config: STRING = "[
		add_album_art:
			music_dir = "workarea/rhythmdb/Music"
		
			album_art_dir = "test-data/rhythmdb/album-art"
		
			create_folders = False
	]"

end