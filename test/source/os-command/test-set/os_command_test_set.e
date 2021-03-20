note
	description: "Os command test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 9:51:49 GMT (Saturday 20th March 2021)"
	revision: "13"

class
	OS_COMMAND_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_COMMAND

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("cpu_info", agent test_cpu_info)
		end

feature -- Tests

	test_cpu_info
		local
			cpu_info_cmd: like Command.new_cpu_info; info_cmd: EL_CAPTURED_OS_COMMAND
		do
			if {PLATFORM}.is_unix then
				cpu_info_cmd := Command.new_cpu_info
				create info_cmd.make_with_name ("cat_cpuinfo", "cat /proc/cpuinfo | grep %"$model_name%" --max-count 1")
				info_cmd.put_string ("model_name", cpu_info_cmd.model_name)
				info_cmd.execute
				assert ("begins with model name", info_cmd.lines.first.starts_with_general ("model name"))
			end
		end

end