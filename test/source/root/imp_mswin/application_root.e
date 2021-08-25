note
	description: "Windows application root with some test apps commented out"
	notes: "[
		Add logged threads into thread.ecf with a variable to include/exclude
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-22 14:10:20 GMT (Sunday 22nd August 2021)"
	revision: "63"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		BATCH_TEST_APP,

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
	--	MULTIMEDIA_AUTOTEST_APP,

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

	-- Test TagLib.ecf (Not yet available in Windows due to contrib/C++ links to external library)
	--	TAGLIB_AUTOTEST_APP,

	-- Test text-formats.ecf
		TEXT_FORMATS_AUTOTEST_APP,

	-- Test text-process.ecf
		TEXT_PROCESS_AUTOTEST_APP,

	-- Test vtd-xml.ecf
		VTD_XML_AUTOTEST_APP,

	-- Test xml-scan.ecf
		XML_SCAN_AUTOTEST_APP,

	-- Test eros.ecf (Run last to give time for socket address to be released from `SIMPLE_CLIENT_SERVER_TEST_APP')
		EROS_AUTOTEST_APP
	]

create
	make

feature {NONE} -- Constants

	Compile_various: TUPLE [
		MY_WET_CLASS, MY_DRY_CLASS, EL_TEST_SET_BRIDGE, LIBGCC1,
		EL_LOGGED_FUNCTION_DISTRIBUTER [ANY],
		EL_LOGGED_PROCEDURE_DISTRIBUTER [ANY],
		EL_LOGGED_WORK_DISTRIBUTER [ROUTINE]
	]
		once
			create Result
		end

	Compile_consumer: TUPLE [
		EL_BATCH_FILE_PROCESSING_THREAD, EL_LOGGED_BATCH_FILE_PROCESSING_THREAD,
		EL_COUNT_CONSUMER_THREAD,
		EL_COUNT_CONSUMER_MAIN_THREAD,
		EL_CONSUMER_MAIN_THREAD [ANY],
		EL_CONSUMER_THREAD [ANY],
		EL_DELEGATING_CONSUMER_THREAD [ANY, EL_MANY_TO_ONE_CONSUMER_THREAD [ANY]],
		EL_LOGGED_CONSUMER [ANY],
		EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER,
		EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD,
		EL_PROCEDURE_CALL_CONSUMER_THREAD,
		EL_PROCEDURE_CALL_QUEUE,
		EL_REGULAR_INTERVAL_EVENT_CONSUMER,
		EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER,
		EL_TIMED_COUNT_PRODUCER,
		EL_TIMED_PROCEDURE,
		EL_TIMED_PROCEDURE_MAIN_THREAD
	]
		once
			create Result
		end

	Compile_thread: TUPLE [
		EL_DORMANT_ACTION_LOOP_THREAD,
		EL_EVENT_LISTENER_MAIN_THREAD_PROXY,
		EL_FILE_PROCESS_THREAD,
		EL_INTERRUPTABLE_THREAD,
		EL_LOGGED_FILE_PROCESS_THREAD,
		EL_LOGGED_DELEGATING_CONSUMER_THREAD [ANY, EL_MANY_TO_ONE_CONSUMER_THREAD [ANY]],
		EL_LOGGED_MANY_TO_ONE_CONSUMER_THREAD [ANY],
		EL_LOGGED_REGULAR_INTERVAL_EVENT_PRODUCER,
		EL_LOGGED_TIMEOUT,
		EL_RHYTHMIC_ACTION_THREAD,
		EL_REGULAR_INTERVAL_EVENT_PRODUCER,
		EL_SEPARATE_PROCEDURE [TUPLE],
		EL_TIMEOUT,
		EL_TIMED_PROCEDURE_THREAD,
		EL_WORKER_THREAD,
		EL_THREAD_PROXY [ANY],
		EL_XML_NETWORK_MESSENGER
	]
		once
			create Result
		end

end