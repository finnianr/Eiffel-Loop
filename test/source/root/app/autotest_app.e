note
	description: "[
		Run all sub-application tests conforming to ${EL_AUTOTEST_APPLICATION}
		and call ${ZSTRING_TEST_SET} a second time using codec ${EL_ISO_8859_1_ZCODEC}.
		
			el_test -autotest -test_set ZSTRING_TEST_SET -zstring_codec ISO-8859-1

		(Default is ${EL_ISO_8859_15_ZCODEC})
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-22 8:09:45 GMT (Monday 22nd July 2024)"
	revision: "13"

class
	AUTOTEST_APP

inherit
	EL_BATCH_AUTOTEST_APP
		redefine
			test
		end

	EL_SHARED_ZCODEC_FACTORY

	EL_ENCODING_TYPE

create
	default_create

feature {NONE} -- Implementation

	test (application: EL_APPLICATION)
		local
			ecf_name: ZSTRING; cmd_list: EL_ZSTRING_LIST; latin_1_: EL_ENCODEABLE_AS_TEXT
		do
			if attached {EL_AUTOTEST_APPLICATION} application as test_app then
				ecf_name := Naming.class_as_kebab_upper (test_app, 0, 2) + Dot_ecf
				ecf_name.to_lower
				lio.put_labeled_string ("Library", ecf_name)
				lio.put_new_line

				create cmd_list.make_from_general (<< hyphen.to_string + application.option_name >>)
				if attached {NETWORK_AUTOTEST_APP} application then
					if Args.has_value (Option_pp) then
					-- eiffel-loop.com ftp
						cmd_list.append_general (<< hyphen * 1 + Option_pp, Args.value (Option_pp) >>)
					end
					call_command (cmd_list)

				elseif attached {BASE_AUTOTEST_APP} application then
					call_command (cmd_list) -- Use default ISO-8859-15 encoding first

				-- Now just string test sets with  ISO-8859-1
					if execution.return_code = 0 then
						create latin_1_.make (Latin_1)
						cmd_list.append_general (<<
							"-test_set", "*STRING*", Codec_factory.Codec_option_name, latin_1_.encoding_name
						>>)
						call_command (cmd_list)
					end
				else
					call_command (cmd_list)
				end
			end
		end

feature {NONE} -- Constants

	Option_pp: STRING = "pp"

end