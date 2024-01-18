note
	description: "Command line interface to class ${UPGRADE_TEST_SET_CALL_BACK_CODE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-11 10:07:12 GMT (Saturday 11th March 2023)"
	revision: "3"

class
	UPGRADE_TEST_SET_CALL_BACK_CODE_APP

obsolete
	"Once-off use"

inherit
	SOURCE_MANIFEST_APPLICATION [UPGRADE_TEST_SET_CALL_BACK_CODE]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "upgrade_test_set"

end