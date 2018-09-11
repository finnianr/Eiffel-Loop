note
	description: "Root class of sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-11 9:56:02 GMT (Tuesday 11th September 2018)"
	revision: "12"

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

				{UNDATED_PHOTOS_APP},

				{CRYPTO_APP},

				{FILTER_INVALID_UTF_8_APP},
				{FTP_BACKUP_APP}, -- uses ftp (depends eposix)
				{HTML_BODY_WORD_COUNTER_APP},
				{JOBSERVE_SEARCH_APP},

				{PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP},
				{PYXIS_ENCRYPTER_APP},
				{PYXIS_TO_XML_APP},
				{PYXIS_TREE_TO_XML_COMPILER_APP},
				{LOCALIZATION_COMMAND_SHELL_APP},
				{PYXIS_TRANSLATION_TREE_COMPILER_APP},

				{THUNDERBIRD_LOCALIZED_HTML_EXPORTER_APP},
				{THUNDERBIRD_WWW_EXPORTER_APP},
				{FILE_TREE_TRANSFORM_SCRIPT_APP},

				{VCF_CONTACT_SPLITTER_APP},
				{VCF_CONTACT_NAME_SWITCHER_APP},

				{XML_TO_PYXIS_APP},
				{YOUTUBE_HD_DOWNLOAD_APP}
			>>
		end

note
	ideas: "[]"

	to_do: "[]"

end
