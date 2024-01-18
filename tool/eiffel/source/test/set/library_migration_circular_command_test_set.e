note
	description: "Test ${LIBRARY_MIGRATION_COMMAND} with classes containing circular dependencies"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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