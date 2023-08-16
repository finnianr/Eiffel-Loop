note
	description: "[
		Run source code publisher in a loop until user types "quit"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-10 18:36:32 GMT (Thursday 10th August 2023)"
	revision: "6"

class
	EIFFEL_VIEW_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH; a_version: STRING; a_cpu_percentage: INTEGER)
		do
			create publisher.make (config_path, a_version, a_cpu_percentage)
			create line.make_empty
		end

feature -- Access

	description: STRING
		do
			Result := "[
				Publishes source code and descriptions of Eiffel projects to a website as static html
			]"
		end

feature -- Basic operations

	execute
		do
			from until publisher.user_quit loop
				publisher.execute
				publisher.ask_user
			end
		end

feature {NONE} -- Internal attributes

	publisher: REPOSITORY_PUBLISHER

	line: ZSTRING
end