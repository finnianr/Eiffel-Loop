note
	description: "Application root class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 14:38:27 GMT (Saturday 1st August 2020)"
	revision: "26"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [
--		Test
		AUTOTEST_APP,
		EDITOR_AUTOTEST_APP,

--		Utilities
		CHECK_LOCALE_STRINGS_APP,
		CLASS_DESCENDANTS_APP,
		CLASS_PREFIX_REMOVAL_APP,
		CODEC_GENERATOR_APP,
		CODE_HIGHLIGHTING_TEST_APP,
		CODEBASE_STATISTICS_APP,

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
	]"
	to_do: "[
		* [Oct 2019] Fix "tests" note not appearing in published page
		* 1st Aug 2020 Throw an exception for invalid cluster names in form doc/config.pyx
	]"
	ideas: "[
		* use lftp to sync with ftp account
		See https://www.linux.com/blog/using-lftp-synchronize-folders-ftp-account
		
		* Create a tool for automatic organisation of OS-specific class implementations
	]"
end
