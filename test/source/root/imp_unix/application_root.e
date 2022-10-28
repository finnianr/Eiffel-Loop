note
	description: "Application root"
	notes: "[
		Add logged threads into thread.ecf with a variable to include/exclude
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 16:37:20 GMT (Friday 28th October 2022)"
	revision: "70"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		AUTOTEST_APP,

	-- For maintenance purposes only
		MEDIA_PLAYER_DUMMY_APP,

		EXPERIMENTS_APP,

	-- Test network.ecf (Do first to give time for socket address to be released for EROS_AUTOTEST_APP)
		NETWORK_AUTOTEST_APP,

	-- Test amazon-instant-access.ecf
		AMAZON_INSTANT_ACCESS_AUTOTEST_APP,

	-- Test base.ecf
		BASE_AUTOTEST_APP,

	-- Test compression.ecf
		COMPRESSION_AUTOTEST_APP,

	-- Test currency.ecf	
		CURRENCY_AUTOTEST_APP,

	-- Test Eco-DB.ecf
		ECO_DB_AUTOTEST_APP,

	-- Test encryption.ecf
		ENCRYPTION_AUTOTEST_APP,

	-- Test eros.ecf
		BEXT_CLIENT_TEST_APP,
		BEXT_SERVER_TEST_APP,
		FOURIER_MATH_CLIENT_TEST_APP,
		FOURIER_MATH_SERVER_TEST_APP,

	-- Test evolicity.ecf
		EVOLICITY_AUTOTEST_APP,

	-- Test http-client.ecf
		HTTP_CLIENT_AUTOTEST_APP,

	-- Test i18n.ecf
		I18N_AUTOTEST_APP,

	-- Test image-utils.ecf
		IMAGE_UTILS_AUTOTEST_APP,

	-- Test markup-docs.pecf
		OPEN_OFFICE_AUTOTEST_APP,
		THUNDERBIRD_AUTOTEST_APP,

	-- multi-media.ecf
		MULTIMEDIA_AUTOTEST_APP,

	-- Test os-command.ecf
		OS_COMMAND_AUTOTEST_APP,

	-- Test paypal-SBM.ecf
		PAYPAL_STANDARD_BUTTON_MANAGER_AUTOTEST_APP,

	-- Test pyxis-scan.ecf
		PYXIS_SCAN_AUTOTEST_APP,

	--	Test public-key-encryption.ecf
		PUBLIC_KEY_ENCRYPTION_AUTOTEST_APP,

	-- Test search-engine.ecf
		SEARCH_ENGINE_AUTOTEST_APP,

	-- Test TagLib.ecf
		TAGLIB_AUTOTEST_APP,

	-- Test text-formats.ecf
		TEXT_FORMATS_AUTOTEST_APP,

	-- Test text-process.ecf
		TEXT_PROCESS_AUTOTEST_APP,

	-- Test text-process-fast.ecf
		TEXT_PROCESS_FAST_AUTOTEST_APP,

	-- Test vtd-xml.ecf
		VTD_XML_AUTOTEST_APP,

	-- Test xml-scan.ecf
		XML_SCAN_AUTOTEST_APP,

	-- Test eros.ecf (Run last to give time for socket address to be released from `SIMPLE_CLIENT_SERVER_TEST_APP')
		EROS_AUTOTEST_APP
	]
		redefine
			create_singletons
		end

	INCLUDE_CLASSES

create
	make

feature {NONE} -- Implementation

	create_singletons
		do
			Precursor
			-- Ensure LD_LIBRARY_PATH set for Unix
			Execution_environment.set_library_path
		end

end