note
	description: "MP3 audio signature reader"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:56:06 GMT (Monday 23rd September 2024)"
	revision: "14"

class
	EL_MP3_AUDIO_SIGNATURE_READER

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_LIO
	EL_MODULE_OS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_music_dir: like music_dir; clean_up: BOOLEAN)
		do
			music_dir := a_music_dir
			create mp3_path_table.make_equal (111)
			is_clean_up := clean_up
		end

feature -- Constants

	Description: STRING = "Read MP3 audio signatures"

feature -- Basic operations

	execute
		local
			mp3: EL_MP3_IDENTIFIER
		do
			across OS.file_list (music_dir, "*.mp3") as mp3_path loop
				create mp3.make (mp3_path.item)
				mp3_path_table.put (mp3_path.item, mp3.audio_id)
				if mp3_path_table.inserted then
					lio.put_character ('.')
					if mp3_path.cursor_index \\ 100 = 0 then
						lio.put_new_line
					end
				else
					lio.put_new_line
					remove_duplicate (mp3.audio_id.out, mp3_path.item, mp3_path_table.found_item)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Status query

	is_clean_up: BOOLEAN

feature {NONE} -- Implementation

	mp3_path_table: EL_HASH_TABLE [FILE_PATH, EL_UUID]

	music_dir: DIR_PATH

	remove_duplicate (mp3: STRING; file_1, file_2: FILE_PATH)
		local
			l_file_1, l_file_2: FILE_PATH
		do
			lio.enter_with_args ("remove_duplicate", [mp3, file_1, file_2])
			if is_clean_up then
				l_file_1 := file_1.without_extension; l_file_1.remove_extension
				l_file_2 := file_2.without_extension; l_file_2.remove_extension
				if l_file_1 ~ l_file_2 then
					lio.put_path_field ("Removed %S", file_2)
					lio.put_new_line
					OS.File_system.remove_file (file_2)
				end
			end
			lio.exit
		end

end