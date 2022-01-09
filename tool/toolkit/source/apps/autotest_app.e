note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-09 16:30:15 GMT (Sunday 9th January 2022)"
	revision: "15"

class
	AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [
		CAD_MODEL_TEST_SET,
		FILE_MANIFEST_TEST_SET,
		FTP_BACKUP_TEST_SET,
		HTML_BODY_WORD_COUNTER_TEST_SET,
		LOCALIZATION_COMMAND_SHELL_TEST_SET,
		MONTHLY_STOCK_USE_TEST_SET
	]
		redefine
			Visible_types, log_filter_set
		end

create
	make

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, ARCHIVE_FILE
	]
		do
			create Result.make
		end

	visible_types: TUPLE [EL_FTP_PROTOCOL, EL_OS_COMMAND]
		do
			create Result
		end

end