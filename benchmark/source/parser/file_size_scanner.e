note
	description: "Scan Rhythmbox database for total file size"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 7:37:52 GMT (Thursday 27th July 2023)"
	revision: "1"

deferred class
	FILE_SIZE_SCANNER

inherit
	RHYTHMBOX_CONSTANTS
		redefine
			User_config_dir
		end

	EL_MODULE_LIO; EL_MODULE_EXECUTABLE

feature {NONE} -- Initialization

	make
		do
			make_from_file (Rhythmbox_db_path)
		end

feature -- Access

	size_count: NATURAL_64

feature {NONE} -- Event handlers

	increment_size_count
			--
		do
			size_count := size_count + node.to_natural_64
		end

feature {NONE} -- Deferred

	make_from_file (a_file_path: FILE_PATH)
		deferred
		end

	node: EL_DOCUMENT_NODE_STRING
		deferred
		end

feature {NONE} -- Constants

	User_config_dir: DIR_PATH
		once
			if Executable.Is_work_bench then
				Result := "$EIFFEL_LOOP/example/manage-mp3/test-data/rhythmdb"
				Result.expand
			else
				Result := Precursor
			end
		end

end