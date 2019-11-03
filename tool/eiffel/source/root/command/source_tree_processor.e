note
	description: "Source tree processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-07 10:30:15 GMT (Monday 7th October 2019)"
	revision: "8"

class
	SOURCE_TREE_PROCESSOR

inherit
	EL_DIRECTORY_TREE_FILE_PROCESSOR
		rename
			make as make_processor
		end

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_path: like source_dir; new_editor: FUNCTION [LIST [EL_FILE_PATH], EL_EIFFEL_SOURCE_EDITOR])
			--
		do
			make_processor (a_path, "*.e", create {EL_DEFAULT_FILE_PROCESSING_COMMAND})
			create {EDITING_COMMAND} file_processor.make (new_editor (file_path_list))
		end

end
