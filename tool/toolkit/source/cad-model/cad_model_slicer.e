note
	description: "Command to slice CAD model across water plane into dry part and wet part"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 9:57:58 GMT (Tuesday 8th February 2022)"
	revision: "7"

class
	CAD_MODEL_SLICER

inherit
	EL_APPLICATION_COMMAND
		redefine
			description
		end

	EL_MODULE_LOG

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_json_path: FILE_PATH)
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

feature -- Constants

	Description: STRING = "Slice CAD model across water plane into dry part and wet part and save as 2 files"

feature -- Basic operations

	execute
		local
			file_path: FILE_PATH
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

	qualified_path (qualifier: STRING): FILE_PATH
		do
			Result := json_path.without_extension
			Result.set_base (Base_template #$ [Result.base, qualifier])
		end

feature {NONE} -- Internal attributes

	json_path: FILE_PATH

	model: CAD_MODEL

feature {NONE} -- Constants

	Base_template: ZSTRING
		once
			Result := "%S-%S.json"
		end

end