note
	description: "Autotest development app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-24 7:00:39 GMT (Wednesday 24th July 2024)"
	revision: "26"

class
	AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [
		CAD_MODEL_TEST_SET,
		FILE_MANIFEST_TEST_SET,
		FTP_BACKUP_TEST_SET,
		HTML_BODY_WORD_COUNTER_TEST_SET,
		LOCALIZATION_COMMAND_SHELL_TEST_SET,
		MONTHLY_STOCK_USE_TEST_SET,
		PYXIS_TREE_TO_XML_COMPILER_TEST_SET,
		PYXIS_ENCRYPTER_TEST_SET,
		JPEG_FILE_INFO_COMMAND_TEST_SET,
		VCF_CONTACT_TEST_SET
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

	visible_types: TUPLE [
		EL_FTP_PROTOCOL, EL_OS_COMMAND, EL_MERGED_PYXIS_LINE_LIST
	]
		do
			create Result
		end

end