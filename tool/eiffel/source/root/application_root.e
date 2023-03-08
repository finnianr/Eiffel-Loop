note
	description: "Application root class"
	to_do: "[

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-07 9:04:30 GMT (Tuesday 7th March 2023)"
	revision: "48"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
	--	Test
		AUTOTEST_APP,

	-- Analysis
		CHECK_LOCALE_STRINGS_APP,
		CLASS_DESCENDANTS_APP,
		CODEBASE_STATISTICS_APP,
		ENCODING_CHECK_APP,
		REGULAR_EXPRESSION_SEARCH_APP,
		REPOSITORY_NOTE_LINK_CHECKER_APP,
		UNDEFINE_PATTERN_COUNTER_APP,

	-- Class editing
		CLASS_RENAMING_APP,
		FEATURE_EDITOR_APP,
		FIND_AND_REPLACE_APP,
		NOTE_DATE_FIXER_APP,
		NOTE_EDITOR_APP,
		OPEN_GREP_RESULT_APP,
		SOURCE_FILE_NAME_NORMALIZER_APP,
		SOURCE_LEADING_SPACE_CLEANER_APP,
		SOURCE_LOG_LINE_REMOVER_APP,
		UPGRADE_DEFAULT_POINTER_SYNTAX_APP,
		UPGRADE_LOG_FILTERS_APP,

	-- Code generators
		ZCODEC_GENERATOR_APP,
		ID3_FRAME_CODE_CLASS_GENERATOR_APP,
		LIBRARY_OVERRIDE_APP,

	--	Utilities
		GITHUB_MANAGER_APP,

		ECF_TO_PECF_APP,
		EIFFEL_VIEW_APP,

		LIBRARY_MIGRATION_APP,

		IMP_CLASS_LOCATION_NORMALIZER_APP,

		PYXIS_TRANSLATION_TREE_COMPILER_APP,
		PYXIS_ECF_CONVERTER_APP,

		REPOSITORY_SOURCE_LINK_EXPANDER_APP,

		VERSION_MANAGER_APP,
		WINZIP_SOFTWARE_PACKAGE_BUILDER_APP
	]

create
	make

note
	notes: "[
		Needs some work on EL_FTP_SYNC to ensure correct sync info is saved in case of network error.
	]"
	to_do: "[
		* [Oct 2019] Fix "tests" note not appearing in published page
	]"
	ideas: "[
		* use lftp to sync with ftp account
		See https://www.linux.com/blog/using-lftp-synchronize-folders-ftp-account
		
		* Create a tool for automatic organisation of OS-specific class implementations
	]"
end