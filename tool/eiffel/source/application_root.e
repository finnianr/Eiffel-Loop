note
	description: "Application root class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-11 11:18:50 GMT (Wednesday 11th April 2018)"
	revision: "10"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Implementation

	Application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		once
			Result := <<
				{AUTOTEST_DEVELOPMENT_APP},

				{CODEC_GENERATOR_APP},

				{CHECK_LOCALE_STRINGS_APP},

				{CLASS_PREFIX_REMOVAL_APP},

				{CODE_HIGHLIGHTING_TEST_APP},
				{CODEBASE_STATISTICS_APP},

				{ECF_TO_PECF_APP},
				{ENCODING_CHECK_APP},

				{FEATURE_EDITOR_APP},
				{FIND_AND_REPLACE_APP},

				{LIBRARY_OVERRIDE_APP},
				{NOTE_EDITOR_APP},

				{UNDEFINE_PATTERN_COUNTER_APP},
				{UPGRADE_DEFAULT_POINTER_SYNTAX_APP},
				{UPGRADE_LOG_FILTERS_APP},
				{REPOSITORY_PUBLISHER_APP},
				{REPOSITORY_NOTE_LINK_CHECKER_APP},

				{SOURCE_FILE_NAME_NORMALIZER_APP},
				{SOURCE_LOG_LINE_REMOVER_APP},
				{SOURCE_TREE_CLASS_RENAME_APP}

			>>
		end

	tuple: TUPLE
		do
		end
note
	ideas: "[
		use lftp to sync with ftp account
		See https://www.linux.com/blog/using-lftp-synchronize-folders-ftp-account
	]"
end
