note
	description: "Root class of sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-13 15:15:56 GMT (Thursday 13th December 2018)"
	revision: "17"

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

				{CRYPTO_COMMAND_SHELL_APP},

				{FILTER_INVALID_UTF_8_APP},
				{FILE_TREE_TRANSFORM_SCRIPT_APP},
				{FTP_BACKUP_APP}, -- uses ftp (depends eposix)
				{FILE_MANIFEST_APP},

				{HTML_BODY_WORD_COUNTER_APP},
				{JOBSERVE_SEARCH_APP},

				{PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP},
				{PYXIS_ENCRYPTER_APP},
				{PYXIS_TO_XML_APP},
				{PYXIS_TREE_TO_XML_COMPILER_APP},
				{PYXIS_TRANSLATION_TREE_COMPILER_APP},

				{LOCALIZATION_COMMAND_SHELL_APP},
				{LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP},
				{LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP},

				{THUNDERBIRD_WWW_EXPORTER_APP},

				{UNDATED_PHOTO_FINDER_APP},

				{VCF_CONTACT_SPLITTER_APP},
				{VCF_CONTACT_NAME_SWITCHER_APP},

				{XML_TO_PYXIS_APP},
				{YOUTUBE_VIDEO_DOWNLOADER_APP}
			>>
		end

note
	ideas: "[]"

	to_do: "[]"

end
