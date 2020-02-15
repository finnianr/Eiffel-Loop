note
	description: "Command to separate floating CAD model into dry part and wet part"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-15 19:52:07 GMT (Saturday 15th February 2020)"
	revision: "1"

class
	WET_DRY_GEOMETRY_SEPARATOR

inherit
	EL_COMMAND

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_json_path: EL_FILE_PATH)
		do
			create model.make_from_file (a_json_path)
		end

feature -- Basic operations

	execute
		do
		end

feature {NONE} -- Internal attributes

	dry_json_path: EL_FILE_PATH

	wet_json_path: EL_FILE_PATH

	model: CAD_MODEL

end
