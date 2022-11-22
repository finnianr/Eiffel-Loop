note
	description: "[
		Finalized executable tests for legacy library
		[./library/text-process-legacy.html text-process-legacy.ecf]
	]"
	notes: "[
		Command option: `-text_process_legacy_autotest'
		
		**Test Sets**
		
			[$source LEGACY_PARSER_TEST_SET]
			[$source EIFFEL_LEGACY_PARSING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-22 7:16:52 GMT (Tuesday 22nd November 2022)"
	revision: "14"

class
	TEXT_PROCESS_LEGACY_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		LEGACY_PARSER_TEST_SET,
		LEGACY_EIFFEL_PARSING_TEST_SET
	]

create
	make

end
