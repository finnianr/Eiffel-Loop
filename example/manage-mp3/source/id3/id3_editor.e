note
	description: "Summary description for {ID3_READER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ID3_EDITOR

inherit
	EL_COMMAND

	EL_MODULE_LOG

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATTION} -- Initialization

	make (a_media_dir: EL_DIR_PATH; a_edit_action: like edit_action)
		do
			edit_action := a_edit_action
			create file_paths.make (a_media_dir, "*.mp3")
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			across file_paths as mp3_path loop
				edit_action.call ([mp3_path.item, create {EL_ID3_INFO}.make (mp3_path.item)])
			end
			log.exit
		end

feature {NONE} -- Implementation

	edit_action: PROCEDURE [ID3_EDITS, TUPLE [EL_FILE_PATH, EL_ID3_INFO]]

	file_paths: EL_FILE_PATH_LIST

end
