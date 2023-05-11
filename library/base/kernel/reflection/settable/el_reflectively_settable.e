note
	description: "[
		Object with `field_table' attribute of field getter-setter's. See class [$source EL_REFLECTED_FIELD_TABLE]
	]"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		Override `use_default_values' to return `False' if the default values set
		by `set_default_values' is not required.
	]"
	tests: "Class [$source REFLECTION_TEST_SET]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-10 14:25:43 GMT (Wednesday 10th May 2023)"
	revision: "30"

deferred class
	EL_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVE
		redefine
			is_equal
		end

	EL_MAKEABLE
		rename
			make as make_default
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		do
			if use_default_values then
				initialize_fields
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := all_fields_equal (other)
		end

feature -- Basic operations

	write_to (writable: EL_WRITABLE)
		do
			meta_data.field_list.write (Current, writable)
		end

	write_to_memory (memory: EL_MEMORY_READER_WRITER)
		do
			meta_data.field_list.write_to_memory (Current, memory)
		end

feature {NONE} -- Implementation

	use_default_values: BOOLEAN
		do
			Result := True
		end

note
	descendants: "[
			EL_REFLECTIVELY_SETTABLE*
				[$source MY_DRY_CLASS]
				[$source AIA_CREDENTIAL_ID]
				[$source FCGI_REQUEST_PARAMETERS]
				[$source AIA_RESPONSE]
					[$source AIA_GET_USER_ID_RESPONSE]
					[$source AIA_FAIL_RESPONSE]
					[$source AIA_PURCHASE_RESPONSE]
						[$source AIA_REVOKE_RESPONSE]
				[$source COUNTRY]
					[$source CAMEL_CASE_COUNTRY]
				[$source EL_HTTP_HEADERS]
				[$source PP_TRANSACTION]
				[$source JOB]
				[$source JSON_CURRENCY]
				[$source PERSON]
				[$source EL_OS_COMMAND_I]*
					[$source EL_AVCONV_OS_COMMAND_I]*
						[$source EL_VIDEO_TO_MP3_COMMAND_I]*
						[$source EL_AUDIO_PROPERTIES_COMMAND_I]*
							[$source EL_AUDIO_PROPERTIES_COMMAND_IMP]
						[$source EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I]*
							[$source EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMP]
					[$source EL_OS_COMMAND_IMP]*
						[$source EL_COPY_TREE_COMMAND_IMP]
						[$source EL_OS_COMMAND]
							[$source EL_CAPTURED_OS_COMMAND]
								[$source EL_GVFS_OS_COMMAND]
									[$source EL_GVFS_FILE_INFO_COMMAND]
									[$source EL_GVFS_REMOVE_FILE_COMMAND]
									[$source EL_GVFS_FILE_LIST_COMMAND]
									[$source EL_GVFS_FILE_COUNT_COMMAND]
									[$source EL_GVFS_FILE_EXISTS_COMMAND]
								[$source EL_PARSED_CAPTURED_OS_COMMAND]* [VARIABLES -> [$source TUPLE] create default_create end]
									[$source EL_MD5_SUM_COMMAND]
							[$source EL_PARSED_OS_COMMAND]* [VARIABLES -> [$source TUPLE] create default_create end]
								[$source EL_CREATE_TAR_COMMAND]
								[$source EL_PARSED_CAPTURED_OS_COMMAND]* [VARIABLES -> [$source TUPLE] create default_create end]
						[$source EL_DELETE_FILE_COMMAND_IMP]
						[$source EL_COPY_FILE_COMMAND_IMP]
						[$source EL_CREATE_LINK_COMMAND_IMP]
						[$source EL_DELETE_TREE_COMMAND_IMP]
						[$source EL_FIND_DIRECTORIES_COMMAND_IMP]
						[$source EL_FIND_FILES_COMMAND_IMP]
						[$source EL_MAKE_DIRECTORY_COMMAND_IMP]
						[$source EL_MOVE_FILE_COMMAND_IMP]
						[$source EL_MOVE_TO_DIRECTORY_COMMAND_IMP]
						[$source EL_SEND_MAIL_COMMAND_IMP]
						[$source EL_CPU_INFO_COMMAND_IMP]
						[$source EL_JPEG_FILE_INFO_COMMAND_IMP]
						[$source EL_USERS_INFO_COMMAND_IMP]
						[$source EL_DIRECTORY_INFO_COMMAND_IMP]
						[$source EL_WAV_TO_MP3_COMMAND_IMP]
						[$source EL_EXTRACT_MP3_INFO_COMMAND_IMP]
						[$source EL_AUDIO_PROPERTIES_COMMAND_IMP]
						[$source EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMP]
						[$source EL_WAV_FADER_IMP]
						[$source EL_WAV_GENERATION_COMMAND_IMP]
						[$source EL_X509_PUBLIC_READER_COMMAND_IMP]
						[$source EL_X509_PRIVATE_READER_COMMAND_IMP]
					[$source EL_OS_COMMAND]
					[$source EL_CAPTURED_OS_COMMAND_I]*
						[$source EL_CAPTURED_OS_COMMAND]
						[$source EL_FIND_COMMAND_I]*
							[$source EL_FIND_DIRECTORIES_COMMAND_I]*
								[$source EL_FIND_DIRECTORIES_COMMAND_IMP]
							[$source EL_FIND_FILES_COMMAND_I]*
								[$source EL_FIND_FILES_COMMAND_IMP]
						[$source EL_X509_CERTIFICATE_READER_COMMAND_I]*
							[$source EL_X509_PRIVATE_READER_COMMAND_I]*
								[$source EL_X509_PRIVATE_READER_COMMAND_IMP]
							[$source EL_X509_PUBLIC_READER_COMMAND_I]*
								[$source EL_X509_PUBLIC_READER_COMMAND_IMP]
						[$source EL_CPU_INFO_COMMAND_I]*
							[$source EL_CPU_INFO_COMMAND_IMP]
						[$source EL_JPEG_FILE_INFO_COMMAND_I]*
							[$source EL_JPEG_FILE_INFO_COMMAND_IMP]
						[$source EL_SEND_MAIL_COMMAND_I]*
							[$source EL_SEND_MAIL_COMMAND_IMP]
						[$source EL_USERS_INFO_COMMAND_I]*
							[$source EL_USERS_INFO_COMMAND_IMP]
						[$source EL_DIRECTORY_INFO_COMMAND_I]*
							[$source EL_DIRECTORY_INFO_COMMAND_IMP]
						[$source EL_EXTRACT_MP3_INFO_COMMAND_I]*
							[$source EL_EXTRACT_MP3_INFO_COMMAND_IMP]
					[$source EL_SINGLE_PATH_OPERAND_COMMAND_I]*
						[$source EL_DOUBLE_PATH_OPERAND_COMMAND_I]*
							[$source EL_FILE_CONVERSION_COMMAND_I]*
								[$source EL_VIDEO_TO_MP3_COMMAND_I]*
								[$source EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I]*
								[$source EL_WAV_FADER_I]*
									[$source EL_WAV_FADER_IMP]
								[$source EL_WAV_TO_MP3_COMMAND_I]*
									[$source EL_WAV_TO_MP3_COMMAND_IMP]
							[$source EL_FILE_RELOCATION_COMMAND_I]*
								[$source EL_COPY_TREE_COMMAND_I]*
									[$source EL_COPY_TREE_COMMAND_IMP]
								[$source EL_COPY_FILE_COMMAND_I]*
									[$source EL_COPY_FILE_COMMAND_IMP]
								[$source EL_MOVE_FILE_COMMAND_I]*
									[$source EL_MOVE_FILE_COMMAND_IMP]
							[$source EL_CREATE_LINK_COMMAND_I]*
								[$source EL_CREATE_LINK_COMMAND_IMP]
							[$source EL_MOVE_TO_DIRECTORY_COMMAND_I]*
								[$source EL_MOVE_TO_DIRECTORY_COMMAND_IMP]
						[$source EL_DIR_PATH_OPERAND_COMMAND_I]*
							[$source EL_FIND_COMMAND_I]*
							[$source EL_DELETE_TREE_COMMAND_I]*
								[$source EL_DELETE_TREE_COMMAND_IMP]
							[$source EL_MAKE_DIRECTORY_COMMAND_I]*
								[$source EL_MAKE_DIRECTORY_COMMAND_IMP]
							[$source EL_USERS_INFO_COMMAND_I]*
							[$source EL_DIRECTORY_INFO_COMMAND_I]*
						[$source EL_EXTRACT_MP3_INFO_COMMAND_I]*
						[$source EL_AUDIO_PROPERTIES_COMMAND_I]*
						[$source EL_WAV_GENERATION_COMMAND_I]*
							[$source EL_WAV_GENERATION_COMMAND_IMP]
						[$source EL_FILE_PATH_OPERAND_COMMAND_I]*
							[$source EL_X509_CERTIFICATE_READER_COMMAND_I]*
							[$source EL_DELETE_FILE_COMMAND_I]*
								[$source EL_DELETE_FILE_COMMAND_IMP]
							[$source EL_JPEG_FILE_INFO_COMMAND_I]*
				[$source EL_COMMAND_LINE_OPTIONS]*
					[$source EL_APPLICATION_COMMAND_OPTIONS]
						[$source EROS_APPLICATION_COMMAND_OPTIONS]
					[$source EL_BASE_COMMAND_OPTIONS]
					[$source EL_LOG_COMMAND_OPTIONS]
				[$source AIA_REQUEST]*
					[$source AIA_GET_USER_ID_REQUEST]
					[$source AIA_PURCHASE_REQUEST]
						[$source AIA_REVOKE_REQUEST]
				[$source FCGI_HTTP_HEADERS]
				[$source EL_IP_ADDRESS_GEOLOCATION]
					[$source EL_IP_ADDRESS_GEOGRAPHIC_INFO]
				[$source PP_ADDRESS]
				[$source EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]*
					[$source EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN]*
						[$source EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML]*
							[$source TEST_CONFIGURATION]
						[$source EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS]*
					[$source TEST_VALUES]
					[$source EL_FILE_MANIFEST_ITEM]
				[$source EL_REFLECTIVE_LOCALE_TEXTS]*
					[$source EL_MONTH_TEXTS]
					[$source EL_DAY_OF_WEEK_TEXTS]
					[$source EL_CURRENCY_TEXTS]
					[$source EL_WORD_TEXTS]
					[$source EL_UNINSTALL_TEXTS]
					[$source EL_PASSPHRASE_TEXTS]
					[$source EL_PHRASE_TEXTS]
				[$source EL_DYNAMIC_MODULE_POINTERS]
					[$source EL_IMAGE_UTILS_API_POINTERS]
					[$source EL_CURL_API_POINTERS]
				[$source AIA_AUTHORIZATION_HEADER]
				[$source EL_REFLECTIVELY_SETTABLE_STORABLE]*
					[$source AIA_CREDENTIAL]
					[$source EL_UUID]
					[$source TEST_STORABLE]
					[$source EL_REFLECTIVE_RSA_KEY]*
						[$source EL_RSA_PRIVATE_KEY]
						[$source EL_RSA_PUBLIC_KEY]
					[$source EL_COMMA_SEPARATED_WORDS]
					[$source EL_STORABLE_IMPL]
					[$source EL_TRANSLATION_ITEM]
				[$source EL_ENUMERATION]* [N -> [$source NUMERIC]]
					[$source AIA_RESPONSE_ENUM]
					[$source AIA_REASON_ENUM]
					[$source EL_CURRENCY_ENUM]
					[$source EL_BOOLEAN_ENUMERATION]*
						[$source PP_ADDRESS_STATUS_ENUM]
					[$source PP_PAYMENT_STATUS_ENUM]
					[$source PP_PAYMENT_PENDING_REASON_ENUM]
					[$source PP_TRANSACTION_TYPE_ENUM]
					[$source TL_PICTURE_TYPE_ENUM]
					[$source EL_IPAPI_CO_JSON_FIELD_ENUM]
					[$source EL_DESCRIPTIVE_ENUMERATION]* [N -> {[$source NUMERIC], [$source HASHABLE]}]
						[$source EROS_ERRORS_ENUM]
					[$source TL_STRING_ENCODING_ENUM]
					[$source TL_MUSICBRAINZ_ENUM]
					[$source EL_HTTP_STATUS_ENUM]
					[$source TL_FRAME_ID_ENUM]
	]"
end