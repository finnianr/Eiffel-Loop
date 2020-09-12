note
	description: "[
		Run all sub-application tests conforming to [$source EL_AUTOTEST_SUB_APPLICATION]
		and [$source TEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-12 16:22:35 GMT (Saturday 12th September 2020)"
	revision: "1"

class
	BATCH_TEST_APP

inherit
	EL_SUB_APPLICATION

	EL_SHARED_APPLICATION_LIST

	EL_MODULE_NAMING

create
	default_create

feature {NONE} -- Initiliazation

	initialize
			--
		do
		end

feature -- Basic operations

	run
			--
		local

		do
			across Application_list as app loop
				if not Omission_list.has (app.item.generating_type) then
					test (app.item)
				end
			end
		end

feature {NONE} -- Implementation

	test (application: EL_SUB_APPLICATION)
		local
			ecf_name: ZSTRING; cmd_list: EL_ZSTRING_LIST
		do
			if attached {TEST_SUB_APPLICATION} application as test_app then
				ecf_name := Naming.class_as_kebab_upper (test_app, 0, 1) + Dot_ecf

			elseif attached {EL_AUTOTEST_SUB_APPLICATION} application as test_app then
				ecf_name := Naming.class_as_kebab_upper (test_app, 0, 2) + Dot_ecf

			else
				ecf_name := Dot_ecf
			end
			if ecf_name /= Dot_ecf then
				ecf_name.to_lower
				lio.put_labeled_string ("Library", ecf_name)
				lio.put_new_line
				create cmd_list.make_from_general (<< EL_test_path.to_string, Hypen + application.option_name >>)
				lio.put_line (cmd_list.joined_words)
				lio.put_new_line
				if application.generating_type ~ {BASE_AUTOTEST_APP} then
					cmd_list.append_general (<< "-single", "-zstring_codec", "ISO-8859-1" >>)
					lio.put_line (cmd_list.joined_words)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Constants

	Description: STRING = "[
		Run all sub-application tests conforming to EL_AUTOTEST_SUB_APPLICATION and TEST_SUB_APPLICATION
	]"

	Dot_ecf: ZSTRING
		once
			Result := ".ecf"
		end

	Hypen: ZSTRING
		once
			Result := "-"
		end

	Omission_list: ARRAY [TYPE [EL_SUB_APPLICATION]]
		once
			Result := << {FTP_TEST_APP}, {FTP_AUTOTEST_APP} >>
			Result.compare_objects
		end

	EL_test_path: EL_FILE_PATH
		once
			Result := "build/$ISE_PLATFORM/package/bin/el_test"
			Result.expand
		end

end
