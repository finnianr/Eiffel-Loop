note
	description: "[
		Access control for tests based on `EQA_TEST_SET'.
		See Larry Rix's [https://github.com/ljr1981/test_extension/blob/master/bridge/test_set_bridge.e explanation].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_TEST_SET_BRIDGE

inherit
	EL_MODULE_DIRECTORY

feature -- Constants

	Test_dir: DIR_PATH
		once
			Result := Directory.current_working #+ "test"
		end
end