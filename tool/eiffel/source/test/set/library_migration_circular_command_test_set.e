note
	description: "Test ${LIBRARY_MIGRATION_COMMAND} with classes containing circular dependencies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	LIBRARY_MIGRATION_CIRCULAR_COMMAND_TEST_SET

inherit
	LIBRARY_MIGRATION_COMMAND_TEST_SET
		redefine
			source_dir
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := "test-data/sources/latin-1/kernel"
		end
end