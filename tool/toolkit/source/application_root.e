note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:33:07 GMT (Sunday 28th July 2013)"
	revision: "6"

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
				{AMAZON_EXERCISE_APP},

				{CREATE_LICENSE_KEY_APP},
				{CREATE_RSA_KEY_PAIR_APP},

				{DEPENDENCY_INSTALLER_APP},
				{CODEC_GENERATOR_APP},

				{EIFFEL_CLASS_EDITOR_APP},
				{EIFFEL_CLASS_LIBRARY_MANIFEST_APP},
				{EIFFEL_CLASS_PREFIX_REMOVAL_APP},

				{EIFFEL_CODE_HIGHLIGHTING_TEST_APP},
				{EIFFEL_ECF_TO_PECF_APP},
				{EIFFEL_FEATURE_LABEL_EXPANDER_APP},
				{EIFFEL_FIND_AND_REPLACE_APP},

				{EIFFEL_UPGRADE_DEFAULT_POINTER_SYNTAX_APP},
				{EIFFEL_UPGRADE_LOG_FILTERS_APP},

				{EIFFEL_SOURCE_FILE_NAME_NORMALIZER_APP},
				{EIFFEL_CODEBASE_STATISTICS_APP},
				{EIFFEL_SOURCE_LOG_LINE_REMOVER_APP},
				{EIFFEL_NOTE_EDITOR_APP},
				{EIFFEL_SOURCE_TREE_CLASS_RENAME_APP},

				{ENCRYPT_FILE_APP},
				{ENCRYPT_TEXT_APP},

				{EXPORT_THUNDERBIRD_HTML_APP},
				{FTP_BACKUP_APP},
				{JOBSERVE_SEARCH_APP},
				{PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP},

				{PYXIS_ENCRYPTER_APP},
				{PYXIS_TO_XML_APP},

				{VCF_CONTACT_SPLITTER_APP},

				{WEB_PUBLISHER_APP},
				{XML_TO_PYXIS_APP}
			>>
		end

note
	to_do: "[
		* Add help info compilation to EL_COMMAND_LINE_SUB_APPLICATTION. Add an attribute
			help_requested: BOOLEAN

	]"
end
