note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 14:52:54 GMT (Saturday 1st July 2017)"
	revision: "8"

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
				{UNDATED_PHOTOS_APP},

				{CRYPTO_APP},

				{FTP_BACKUP_APP}, -- uses ftp (depends eposix)
				{HTML_BODY_WORD_COUNTER_APP},
				{JOBSERVE_SEARCH_APP},

				{PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP},
				{PYXIS_ENCRYPTER_APP},
				{PYXIS_TO_XML_APP},
				{PYXIS_TREE_TO_XML_COMPILER_APP},
				{PYXIS_TRANSLATION_MANAGER_APP},
				{PYXIS_TRANSLATION_TREE_COMPILER_APP},

				{THUNDERBIRD_LOCALIZED_HTML_EXPORTER_APP},
				{THUNDERBIRD_WWW_EXPORTER_APP},

				{VCF_CONTACT_SPLITTER_APP},
				{VCF_CONTACT_NAME_SWITCHER_APP},

				{XML_TO_PYXIS_APP}
			>>
		end

	notes: TUPLE [PROJECT_NOTES, DONE_LIST, TO_DO_LIST]
		do
		end

end
