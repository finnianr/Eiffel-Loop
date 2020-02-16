note
	description: "Command to slice CAD model across water plane into dry part and wet part"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-16 16:44:06 GMT (Sunday 16th February 2020)"
	revision: "3"

class
	CAD_MODEL_SLICER

inherit
	EL_COMMAND

	EL_MODULE_LOG

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_json_path: EL_FILE_PATH)
		do
			log.enter_with_args ("make", [a_json_path.base])
			log.set_timer
			json_path := a_json_path
			lio.put_path_field ("Loading", a_json_path)
			lio.put_new_line
			create model.make_from_file (a_json_path)
			log.put_elapsed_time
			log.exit
		end

feature -- Basic operations

	execute
		local
			file_path: EL_FILE_PATH
		do
			log.enter ("execute")
			log.set_timer
			across << "dry", "wet" >> as qualifer loop
				file_path := qualified_path (qualifer.item)
				lio.put_path_field ("Writing", file_path)
				lio.put_new_line
				if qualifer.cursor_index = 1 then
					model.dry_part.store_as (file_path)
				else
					model.wet_part.store_as (file_path)
				end
			end
			log.put_elapsed_time
			log.exit
		end

feature {NONE} -- Implementation

	qualified_path (qualifier: STRING): EL_FILE_PATH
		do
			Result := json_path.without_extension
			Result.base.append_character ('-')
			Result.base.append_string_general (qualifier)
			Result.add_extension (json_path.extension)
		end

feature {NONE} -- Internal attributes

	json_path: EL_FILE_PATH

	model: CAD_MODEL

end
