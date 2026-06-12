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
	date: "2024-08-26 8:54:30 GMT (Monday 26th August 2024)"
	revision: "14"

class
	AUTOTEST_APP

inherit
	EL_BATCH_AUTOTEST_APP
		rename
			omitted_apps as none_omitted
		redefine
			test
		end

	EL_SHARED_ZCODEC_FACTORY

	EL_ENCODING_TYPE

create
	default_create

feature {NONE} -- Implementation

	test (test_app: EL_AUTOTEST_APPLICATION; extra_arguments: detachable ARRAY [ZSTRING])
		local
			ecf_name: ZSTRING; latin_1_: EL_ENCODEABLE_AS_TEXT
		do
			ecf_name := Naming.class_as_kebab_upper (test_app, 0, 2) + Dot_ecf
			ecf_name.to_lower
			lio.put_labeled_string ("Library", ecf_name)
			lio.put_new_line

			if attached {NETWORK_AUTOTEST_APP} test_app and then Args.has_value (Option_pp) then
			-- eiffel-loop.com ftp
				Precursor (test_app, << hyphen + Option_pp, Args.value (Option_pp) >>)

			elseif attached {BASE_AUTOTEST_APP} test_app then
				Precursor (test_app, Void) -- Use default ISO-8859-15 encoding first

			-- Now just string test sets with  ISO-8859-1
				if execution.return_code = 0 then
					create latin_1_.make (Latin_1)
					Precursor (test_app, <<
						"-test_set", "*STRING*", Codec_factory.Codec_option_name, latin_1_.encoding_name
					>>)
				end
			else
				Precursor (test_app, Void)
			end
		end

feature {NONE} -- Constants

	Option_pp: ZSTRING
		once
			Result := "pp"
		end

end