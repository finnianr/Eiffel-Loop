note
	description: "Os command test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 11:15:35 GMT (Tuesday 18th February 2020)"
	revision: "10"

class
	OS_COMMAND_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_COMMAND

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("cpu_info", agent test_cpu_info)
			eval.call ("adapter_info", agent test_adapter_info)
		end

feature -- Tests

	test_cpu_info
		local
			cpu_info_cmd: like Command.new_cpu_info; info_cmd: EL_CAPTURED_OS_COMMAND
		do
			log.enter ("test_cpu_info")
			if {PLATFORM}.is_unix then
				cpu_info_cmd := Command.new_cpu_info
				create info_cmd.make_with_name ("cat_cpuinfo", "cat /proc/cpuinfo | grep %"$model_name%" --max-count 1")
				info_cmd.put_string ("model_name", cpu_info_cmd.model_name)
				info_cmd.execute
				assert ("begins with model name", info_cmd.lines.first.starts_with_general ("model name"))
			end
			log.exit
		end

	test_adapter_info
		local
			adapter_info_cmd: like Command.new_ip_adapter_info; ifconfig_cmd: EL_CAPTURED_OS_COMMAND
			device: EL_ADAPTER_DEVICE; words: LIST [ZSTRING]
		do
			log.enter ("test_adapter_info")
			if {PLATFORM}.is_unix then
				adapter_info_cmd := Command.new_ip_adapter_info
				across adapter_info_cmd.adapter_list as adapter loop
					create ifconfig_cmd.make ("ifconfig | grep ^$name")
					ifconfig_cmd.put_string ("name", adapter.item.name)
					ifconfig_cmd.execute
					log.put_string_field ("name", adapter.item.name)
					if ifconfig_cmd.lines.is_empty then
						log.put_string (" Unconfirmed")
					else
						ifconfig_cmd.lines.first.right_adjust
						words := ifconfig_cmd.lines.first.split (' ')
						create device.make (words.first)
						device.set_address_from_string (words.last)
						log.put_string (" Confirmed")
						assert ("same name", device.name ~ adapter.item.name)
						assert ("same address", device.address ~ adapter.item.address)
					end
					log.put_new_line
				end
			end
			log.exit
		end

end
