note
	description: "Application root class"
	to_do: "[
		Make a Perl grepper to open sources files in editor
		
			find . -name "*.e" | xargs grep -P EL_MODULE_STRING_[0-9]+
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-02 10:34:13 GMT (Sunday 2nd January 2022)"
	revision: "35"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
	--	Test
		AUTOTEST_APP,
		EDITOR_AUTOTEST_APP,

	--	Utilities
		CHECK_LOCALE_STRINGS_APP,
		CLASS_DESCENDANTS_APP,
		CLASS_PREFIX_REMOVAL_APP,
		CODEC_GENERATOR_APP,
		CODE_HIGHLIGHTING_TEST_APP,
		CODEBASE_STATISTICS_APP,

		GITHUB_MANAGER_APP,

		NOTE_DATE_FIXER_APP,

		ECF_TO_PECF_APP,
		ENCODING_CHECK_APP,
		EIFFEL_VIEW_APP,

		FEATURE_EDITOR_APP,
		FIND_AND_REPLACE_APP,

		ID3_FRAME_CODE_CLASS_GENERATOR_APP,
		IMP_CLASS_LOCATION_NORMALIZER_APP,

		LIBRARY_OVERRIDE_APP,
		NOTE_EDITOR_APP,

		UNDEFINE_PATTERN_COUNTER_APP,
		UPGRADE_DEFAULT_POINTER_SYNTAX_APP,
		UPGRADE_LOG_FILTERS_APP,

		PYXIS_TRANSLATION_TREE_COMPILER_APP,
		PYXIS_ECF_CONVERTER_APP,

		REPOSITORY_SOURCE_LINK_EXPANDER_APP,
		REPOSITORY_NOTE_LINK_CHECKER_APP,

		SOURCE_FILE_NAME_NORMALIZER_APP,
		SOURCE_LOG_LINE_REMOVER_APP,
		CLASS_RENAMING_APP,

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