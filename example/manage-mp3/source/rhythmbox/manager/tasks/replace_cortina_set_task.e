note
	description: "Replace cortina set task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 16:25:49 GMT (Sunday 1st September 2019)"
	revision: "1"

class
	REPLACE_CORTINA_SET_TASK

inherit
	MANAGEMENT_TASK
		redefine
			error_check
		end

create
	make

feature -- Access

	cortina_set: CORTINA_SET_INFO

feature -- Basic operations

	apply
		local
			new_set: CORTINA_SET; cortina_path: EL_FILE_PATH
		do
			log.enter ("apply")
			cortina_path := user_input_file_path ("mp3 for cortina")

			if Database.songs_by_location.has (cortina_path) then
				lio.put_line ("Replacing current set")
				create new_set.make (Database, cortina_set, Database.songs_by_location [cortina_path])
				Database.replace_cortinas (new_set)
				Database.store_all
			else
				lio.put_path_field ("ERROR file not found", cortina_path)
				lio.put_new_line
			end
			log.exit
		end

feature {NONE} -- Implementation

	error_check
		do
			error_message.wipe_out
			if cortina_set.tango_count \\ cortina_set.tangos_per_vals /= 0 then
				error_message := "tango_count must be exactly divisible by tangos_per_vals"
			end
		end
end
