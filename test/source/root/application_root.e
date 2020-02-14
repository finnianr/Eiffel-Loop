note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 11:40:51 GMT (Friday 14th February 2020)"
	revision: "42"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [
		-- For maintenance purposes only
		MEDIA_PLAYER_DUMMY_APP,

		EXPERIMENTS_APP,

		-- Benchmarks
		BENCHMARK_APP,
		ZSTRING_BENCHMARK_APP,

		-- Test amazon-instant-access.ecf
		AMAZON_INSTANT_ACCESS_AUTOTEST_APP,

		-- Test base.ecf
		BASE_AUTOTEST_APP,

		-- Test compression.ecf
		COMPRESSION_TEST_APP,

		-- Test encryption.ecf
		ENCRYPTION_AUTOTEST_APP,

		-- Test eros.ecf
		BEXT_CLIENT_TEST_APP,
		BEXT_SERVER_TEST_APP,
		EROS_AUTOTEST_APP,
		FOURIER_MATH_CLIENT_TEST_APP,
		FOURIER_MATH_SERVER_TEST_APP,

		-- Test evolicity.ecf
		EVOLICITY_TEST_APP,

		-- Test ftp.ecf
		FTP_AUTOTEST_APP,

		-- Test http-client.ecf
		HTTP_CLIENT_AUTOTEST_APP,

		-- Test i18n.ecf
		I18N_AUTOTEST_APP,

		-- Test image-utils.ecf
		IMAGE_UTILS_AUTOTEST_APP,

		-- Test ID3-tags.ecf
		ID3_TAGS_AUTOTEST_APP,

		-- Test markup-docs.pecf
		OPEN_OFFICE_AUTOTEST_APP,
		THUNDERBIRD_AUTOTEST_APP,

		-- Test network.ecf
		SIMPLE_CLIENT_SERVER_TEST_APP,

		-- Test os-command.ecf
		OS_COMMAND_AUTOTEST_APP,

		-- Test paypal-SBM.ecf
		PAYPAL_STANDARD_BUTTON_MANAGER_AUTOTEST_APP,

		-- Test search-engine.ecf
		SEARCH_ENGINE_AUTOTEST_APP,

		-- Test TagLib.ecf
		TAGLIB_AUTOTEST_APP,

		-- Test text-formats.ecf
		TEXT_FORMATS_AUTOTEST_APP,

		-- Test text-process.ecf
		TEXT_PROCESS_AUTOTEST_APP,

		-- Test thread.ecf
		TEST_WORK_DISTRIBUTER_APP,

		-- Test vtd-xml.ecf
		VTD_XML_AUTOTEST_APP,

		-- Test xdoc-scanning.ecf
		XDOC_SCANNING_AUTOTEST_APP
	]
		do
			create Result
		end

	Compile_also: TUPLE [MY_WET_CLASS, MY_DRY_CLASS, EL_TEST_SET_BRIDGE, LIBGCC1]
		once
			create Result
		end

end
