note
	description: "[
		Run source code publisher in a loop until user types "quit"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-05 12:32:29 GMT (Sunday 5th June 2022)"
	revision: "2"

class
	EIFFEL_VIEW_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_file_path: FILE_PATH; a_version: STRING; a_cpu_percentage: INTEGER)
		do
			create publisher.make (a_file_path, a_version, a_cpu_percentage)
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
			from until line.same_string ("quit") loop
				publisher.execute
				line := User_input.line ("Press <Enter> to update (or quit)")
				line.to_lower
			end
		end

feature {NONE} -- Internal attributes

	publisher: REPOSITORY_PUBLISHER

	line: ZSTRING
end