note
	description: "Test [$source LIBRARY_MIGRATION_COMMAND] with classes containing circular dependencies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-12 13:10:10 GMT (Sunday 12th June 2022)"
	revision: "1"

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