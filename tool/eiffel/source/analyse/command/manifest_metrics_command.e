note
	description: "[
		Analyzes each class in a specified source manifest or source directory
		using the class ${CODEBASE_METRICS} and displays metrics
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-17 15:11:12 GMT (Sunday 17th September 2023)"
	revision: "3"

class
	MANIFEST_METRICS_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make_default, execute
		end

	EL_MODULE_FILE_SYSTEM

create
	make, make_default, default_create

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor {SOURCE_MANIFEST_COMMAND}
			create metrics.make
		end

feature -- Access

	Description: STRING = "[
		Count occurrences of identifiers and Eiffel keywords within routine bodies
	]"

	metrics: CODEBASE_METRICS

feature -- Basic operations

	do_with_file (source_path: FILE_PATH)
		do
			metrics.add_file (source_path)
		end

	execute
		do
			Precursor
			lio.put_new_line
			metrics.display
			lio.put_new_line
		end

end