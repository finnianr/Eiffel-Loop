note
	description: "Eqa test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-17 9:18:43 GMT (Sunday 17th May 2020)"
	revision: "5"

deferred class
	EL_EQA_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as ise_file_system
		redefine
			on_prepare
		end

	EL_MODULE_FILE_SYSTEM

feature -- Basic operations

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		deferred
		end

feature {NONE} -- Initialization

	on_prepare
		local
			global: EL_SINGLETON [EL_GLOBAL_LOGGING]
			logging: EL_GLOBAL_LOGGING
		do
			create global
			if not global.is_created then
				create logging.make (False)
			end
		end

end
