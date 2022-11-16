note
	description: "[
		Run all sub-application tests conforming to [$source EL_AUTOTEST_APPLICATION]
		and call [$source ZSTRING_TEST_SET] a second time using codec [$source EL_ISO_8859_1_ZCODEC].
		
			el_test -autotest -test_set ZSTRING_TEST_SET -zstring_codec ISO-8859-1

		(Default is [$source EL_ISO_8859_15_ZCODEC])
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	AUTOTEST_APP

inherit
	EL_BATCH_AUTOTEST_APP
		redefine
			test
		end

create
	default_create

feature {NONE} -- Implementation

	test (application: EL_APPLICATION)
		local
			ecf_name: ZSTRING; cmd_list: EL_ZSTRING_LIST
		do
			if attached {EL_AUTOTEST_APPLICATION} application as test_app then
				ecf_name := Naming.class_as_kebab_upper (test_app, 0, 2) + Dot_ecf
				ecf_name.to_lower
				lio.put_labeled_string ("Library", ecf_name)
				lio.put_new_line
				create cmd_list.make_from_general (<< Hypen + application.option_name >>)
				call_command (cmd_list)
				if application.generating_type ~ {BASE_AUTOTEST_APP} and then execution.return_code = 0 then
					cmd_list.append_general (<<
						"-test_set", ({ZSTRING_TEST_SET}).name.to_string_8, "-zstring_codec", "ISO-8859-1"
					>>)
					call_command (cmd_list)
				end
			end
		end

end