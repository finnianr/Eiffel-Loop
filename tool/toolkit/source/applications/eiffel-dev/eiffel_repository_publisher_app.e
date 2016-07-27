note
	description: "Publishes an Eiffel repository to a website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-13 7:43:24 GMT (Wednesday 13th July 2016)"
	revision: "11"

class
	EIFFEL_REPOSITORY_PUBLISHER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EIFFEL_REPOSITORY_PUBLISHER]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [config_path: EL_FILE_PATH; version: STRING]
		do
			create Result
			Result.config_path := ""
			Result.version := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("config", "Path to publisher configuration file"),
				required_argument ("version", "Repository version number")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "publish_repository"

	Description: STRING = "Publishes an Eiffel repository to a website"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_REPOSITORY_PUBLISHER_APP}, All_routines],
				[{REPOSITORY_SOURCE_TREE}, All_routines],
				[{REPOSITORY_SOURCE_TREE_PAGE}, All_routines]
			>>
		end

end