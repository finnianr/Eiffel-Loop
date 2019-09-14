note
	description: "Application root class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-14 10:04:25 GMT (Saturday   14th   September   2019)"
	revision: "17"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [
		AUTOTEST_DEVELOPMENT_APP,

		CHECK_LOCALE_STRINGS_APP,
		CLASS_DESCENDANTS_APP,
		CLASS_PREFIX_REMOVAL_APP,
		CODEC_GENERATOR_APP,
		CODE_HIGHLIGHTING_TEST_APP,
		CODEBASE_STATISTICS_APP,

		ECF_TO_PECF_APP,
		ENCODING_CHECK_APP,

		FEATURE_EDITOR_APP,
		FIND_AND_REPLACE_APP,

		IMP_CLASS_LOCATION_NORMALIZER_APP,
		LIBRARY_OVERRIDE_APP,

		NOTE_EDITOR_APP,

		UNDEFINE_PATTERN_COUNTER_APP,
		UPGRADE_DEFAULT_POINTER_SYNTAX_APP,
		UPGRADE_LOG_FILTERS_APP,

		EIFFEL_VIEW_APP,
		REPOSITORY_SOURCE_LINK_EXPANDER_APP,
		REPOSITORY_NOTE_LINK_CHECKER_APP,

		SOURCE_FILE_NAME_NORMALIZER_APP,
		SOURCE_LOG_LINE_REMOVER_APP,
		SOURCE_TREE_CLASS_RENAME_APP
	]
		once
			create Result
		end

	Compile_also: TUPLE
		once
			create Result
		end

note
	notes: "[
		Needs some work on EL_FTP_SYNC to ensure correct sync info is saved in case of network error.
	"]
	ideas: "[
		* use lftp to sync with ftp account
		See https://www.linux.com/blog/using-lftp-synchronize-folders-ftp-account
		
		* Create a tool for automatic organisation of OS-specific class implementations
	]"
end
