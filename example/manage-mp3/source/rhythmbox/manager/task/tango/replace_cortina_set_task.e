note
	description: "Replace cortina set task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "6"

class
	REPLACE_CORTINA_SET_TASK

inherit
	RBOX_MANAGEMENT_TASK
		redefine
			make
		end

	DATABASE_UPDATE_TASK

create
	make

feature {RBOX_MUSIC_MANAGER} -- Initialization

	make (a_file_path: FILE_PATH)
		do
			Precursor (a_file_path)
			if cortina_set.tango_count \\ cortina_set.tangos_per_vals /= 0 then
				error_message := "tango_count must be exactly divisible by tangos_per_vals"
			end
		end

feature -- Access

	cortina_set: CORTINA_SET_INFO

feature -- Basic operations

	apply
		local
			new_set: CORTINA_SET; cortina_path: FILE_PATH
		do
			cortina_path := user_input_file_path ("mp3 for cortina")

			if Database.songs_by_location.has (cortina_path) then
				lio.put_line ("Replacing current set")
				create new_set.make (cortina_set, Database.songs_by_location [cortina_path])
				Database.replace_cortinas (new_set)
				Database.store_all
			else
				lio.put_path_field ("ERROR file not found", cortina_path)
				lio.put_new_line
			end
		end

end
