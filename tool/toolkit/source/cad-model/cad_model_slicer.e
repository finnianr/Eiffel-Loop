note
	description: "Command to slice CAD model across water plane into dry part and wet part"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-16 9:11:56 GMT (Sunday 16th February 2020)"
	revision: "2"

class
	CAD_MODEL_SLICER

inherit
	EL_COMMAND

	EL_MODULE_LOG

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_json_path: EL_FILE_PATH)
		do
			log.enter ("make")
			log.set_timer
			create model.make_from_file (a_json_path)
			log.put_elapsed_time
			log.exit
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			log.set_timer
			log.put_elapsed_time
			log.exit
		end

feature {NONE} -- Internal attributes

	dry_json_path: EL_FILE_PATH

	wet_json_path: EL_FILE_PATH

	model: CAD_MODEL

end
