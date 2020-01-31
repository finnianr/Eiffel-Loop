note
	description: "VTD-XML autotest app"
	notes: "Option: `-vtd_xml_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 11:48:13 GMT (Friday 31st January 2020)"
	revision: "2"

class
	VTD_XML_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			new_lio, new_log_manager, log_filter
		end

create
	make

feature {NONE} -- Implementation

	evaluator_type, evaluator_types_all: TUPLE [VTD_XML_TEST_EVALUATOR]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{VTD_XML_TEST_SET}, All_routines]
			>>
		end

	new_lio: EL_LOGGABLE
		do
			create {EL_TESTING_CONSOLE_ONLY_LOG} Result.make
		end

	new_log_manager: EL_TESTING_LOG_MANAGER
		do
			create Result.make (is_logging_active, Log_output_directory)
		end

end
