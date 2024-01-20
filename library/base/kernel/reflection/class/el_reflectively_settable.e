note
	description: "[
		Object with `field_table' attribute of field getter-setter's. See class ${EL_FIELD_TABLE}
	]"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		Override `use_default_values' to return `False' if the default values set
		by `set_default_values' is not required.
	]"
	tests: "Class ${REFLECTION_TEST_SET}"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "38"

deferred class
	EL_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVE
		redefine
			field_comparison, is_equal
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

feature -- Basic operations

	write_to (writable: EL_WRITABLE)
		do
			meta_data.field_list.write (Current, writable)
		end

	write_to_memory (memory: EL_MEMORY_READER_WRITER)
		do
			meta_data.field_list.write_to_memory (Current, memory)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			if field_comparison then
				Result := all_fields_equal (other)
			else
				Result := is_equal_except (other) -- {ANY}.is_equal
			end
		end

feature {NONE} -- Implementation

	use_default_values: BOOLEAN
		do
			Result := True
		end

	field_comparison: BOOLEAN
		do
			Result := True
		end

note
	descendants: "[
			EL_REFLECTIVELY_SETTABLE*
				${MY_DRY_CLASS}
				${AIA_CREDENTIAL_ID}
				${FCGI_REQUEST_PARAMETERS}
				${AIA_RESPONSE}
					${AIA_GET_USER_ID_RESPONSE}
					${AIA_FAIL_RESPONSE}
					${AIA_PURCHASE_RESPONSE}
						${AIA_REVOKE_RESPONSE}
				${COUNTRY}
					${CAMEL_CASE_COUNTRY}
				${EL_HTTP_HEADERS}
				${PP_TRANSACTION}
				${JOB}
				${JSON_CURRENCY}
				${PERSON}
				${EL_OS_COMMAND_I}*
					${EL_AVCONV_OS_COMMAND_I}*
						${EL_VIDEO_TO_MP3_COMMAND_I}*
						${EL_AUDIO_PROPERTIES_COMMAND_I}*
							${EL_AUDIO_PROPERTIES_COMMAND_IMP}
						${EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I}*
							${EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMP}
					${EL_OS_COMMAND_IMP}*
						${EL_COPY_TREE_COMMAND_IMP}
						${EL_OS_COMMAND}
							${EL_CAPTURED_OS_COMMAND}
								${EL_GVFS_OS_COMMAND}
									${EL_GVFS_FILE_INFO_COMMAND}
									${EL_GVFS_REMOVE_FILE_COMMAND}
									${EL_GVFS_FILE_LIST_COMMAND}
									${EL_GVFS_FILE_COUNT_COMMAND}
									${EL_GVFS_FILE_EXISTS_COMMAND}
								${EL_PARSED_CAPTURED_OS_COMMAND}* [VARIABLES -> ${TUPLE} create default_create end]
									${EL_MD5_SUM_COMMAND}
							${EL_PARSED_OS_COMMAND}* [VARIABLES -> ${TUPLE} create default_create end]
								${EL_CREATE_TAR_COMMAND}
								${EL_PARSED_CAPTURED_OS_COMMAND}* [VARIABLES -> ${TUPLE} create default_create end]
						${EL_DELETE_FILE_COMMAND_IMP}
						${EL_COPY_FILE_COMMAND_IMP}
						${EL_CREATE_LINK_COMMAND_IMP}
						${EL_DELETE_TREE_COMMAND_IMP}
						${EL_FIND_DIRECTORIES_COMMAND_IMP}
						${EL_FIND_FILES_COMMAND_IMP}
						${EL_MAKE_DIRECTORY_COMMAND_IMP}
						${EL_MOVE_FILE_COMMAND_IMP}
						${EL_MOVE_TO_DIRECTORY_COMMAND_IMP}
						${EL_SEND_MAIL_COMMAND_IMP}
						${EL_CPU_INFO_COMMAND_IMP}
						${EL_JPEG_FILE_INFO_COMMAND_IMP}
						${EL_USERS_INFO_COMMAND_IMP}
						${EL_DIRECTORY_INFO_COMMAND_IMP}
						${EL_WAV_TO_MP3_COMMAND_IMP}
						${EL_EXTRACT_MP3_INFO_COMMAND_IMP}
						${EL_AUDIO_PROPERTIES_COMMAND_IMP}
						${EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMP}
						${EL_WAV_FADER_IMP}
						${EL_WAV_GENERATION_COMMAND_IMP}
						${EL_X509_PUBLIC_READER_COMMAND_IMP}
						${EL_X509_PRIVATE_READER_COMMAND_IMP}
					${EL_OS_COMMAND}
					${EL_CAPTURED_OS_COMMAND_I}*
						${EL_CAPTURED_OS_COMMAND}
						${EL_FIND_COMMAND_I}*
							${EL_FIND_DIRECTORIES_COMMAND_I}*
								${EL_FIND_DIRECTORIES_COMMAND_IMP}
							${EL_FIND_FILES_COMMAND_I}*
								${EL_FIND_FILES_COMMAND_IMP}
						${EL_X509_CERTIFICATE_READER_COMMAND_I}*
							${EL_X509_PRIVATE_READER_COMMAND_I}*
								${EL_X509_PRIVATE_READER_COMMAND_IMP}
							${EL_X509_PUBLIC_READER_COMMAND_I}*
								${EL_X509_PUBLIC_READER_COMMAND_IMP}
						${EL_CPU_INFO_COMMAND_I}*
							${EL_CPU_INFO_COMMAND_IMP}
						${EL_JPEG_FILE_INFO_COMMAND_I}*
							${EL_JPEG_FILE_INFO_COMMAND_IMP}
						${EL_SEND_MAIL_COMMAND_I}*
							${EL_SEND_MAIL_COMMAND_IMP}
						${EL_USERS_INFO_COMMAND_I}*
							${EL_USERS_INFO_COMMAND_IMP}
						${EL_DIRECTORY_INFO_COMMAND_I}*
							${EL_DIRECTORY_INFO_COMMAND_IMP}
						${EL_EXTRACT_MP3_INFO_COMMAND_I}*
							${EL_EXTRACT_MP3_INFO_COMMAND_IMP}
					${EL_SINGLE_PATH_OPERAND_COMMAND_I}*
						${EL_DOUBLE_PATH_OPERAND_COMMAND_I}*
							${EL_FILE_CONVERSION_COMMAND_I}*
								${EL_VIDEO_TO_MP3_COMMAND_I}*
								${EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I}*
								${EL_WAV_FADER_I}*
									${EL_WAV_FADER_IMP}
								${EL_WAV_TO_MP3_COMMAND_I}*
									${EL_WAV_TO_MP3_COMMAND_IMP}
							${EL_FILE_RELOCATION_COMMAND_I}*
								${EL_COPY_TREE_COMMAND_I}*
									${EL_COPY_TREE_COMMAND_IMP}
								${EL_COPY_FILE_COMMAND_I}*
									${EL_COPY_FILE_COMMAND_IMP}
								${EL_MOVE_FILE_COMMAND_I}*
									${EL_MOVE_FILE_COMMAND_IMP}
							${EL_CREATE_LINK_COMMAND_I}*
								${EL_CREATE_LINK_COMMAND_IMP}
							${EL_MOVE_TO_DIRECTORY_COMMAND_I}*
								${EL_MOVE_TO_DIRECTORY_COMMAND_IMP}
						${EL_DIR_PATH_OPERAND_COMMAND_I}*
							${EL_FIND_COMMAND_I}*
							${EL_DELETE_TREE_COMMAND_I}*
								${EL_DELETE_TREE_COMMAND_IMP}
							${EL_MAKE_DIRECTORY_COMMAND_I}*
								${EL_MAKE_DIRECTORY_COMMAND_IMP}
							${EL_USERS_INFO_COMMAND_I}*
							${EL_DIRECTORY_INFO_COMMAND_I}*
						${EL_EXTRACT_MP3_INFO_COMMAND_I}*
						${EL_AUDIO_PROPERTIES_COMMAND_I}*
						${EL_WAV_GENERATION_COMMAND_I}*
							${EL_WAV_GENERATION_COMMAND_IMP}
						${EL_FILE_PATH_OPERAND_COMMAND_I}*
							${EL_X509_CERTIFICATE_READER_COMMAND_I}*
							${EL_DELETE_FILE_COMMAND_I}*
								${EL_DELETE_FILE_COMMAND_IMP}
							${EL_JPEG_FILE_INFO_COMMAND_I}*
				${EL_COMMAND_LINE_OPTIONS}*
					${EL_APPLICATION_COMMAND_OPTIONS}
						${EROS_APPLICATION_COMMAND_OPTIONS}
					${EL_BASE_COMMAND_OPTIONS}
					${EL_LOG_COMMAND_OPTIONS}
				${AIA_REQUEST}*
					${AIA_GET_USER_ID_REQUEST}
					${AIA_PURCHASE_REQUEST}
						${AIA_REVOKE_REQUEST}
				${FCGI_HTTP_HEADERS}
				${EL_IP_ADDRESS_GEOLOCATION}
					${EL_IP_ADDRESS_GEOGRAPHIC_INFO}
				${PP_ADDRESS}
				${EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}*
					${EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN}*
						${EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML}*
							${TEST_CONFIGURATION}
						${EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS}*
					${TEST_VALUES}
					${EL_FILE_MANIFEST_ITEM}
				${EL_REFLECTIVE_LOCALE_TEXTS}*
					${EL_MONTH_TEXTS}
					${EL_DAY_OF_WEEK_TEXTS}
					${EL_CURRENCY_TEXTS}
					${EL_WORD_TEXTS}
					${EL_UNINSTALL_TEXTS}
					${EL_PASSPHRASE_TEXTS}
					${EL_PHRASE_TEXTS}
				${EL_DYNAMIC_MODULE_POINTERS}
					${EL_IMAGE_UTILS_API_POINTERS}
					${EL_CURL_API_POINTERS}
				${AIA_AUTHORIZATION_HEADER}
				${EL_REFLECTIVELY_SETTABLE_STORABLE}*
					${AIA_CREDENTIAL}
					${EL_UUID}
					${TEST_STORABLE}
					${EL_REFLECTIVE_RSA_KEY}*
						${EL_RSA_PRIVATE_KEY}
						${EL_RSA_PUBLIC_KEY}
					${EL_COMMA_SEPARATED_WORDS}
					${EL_STORABLE_IMPL}
					${EL_TRANSLATION_ITEM}
				${EL_ENUMERATION}* [N -> ${NUMERIC}]
					${AIA_RESPONSE_ENUM}
					${AIA_REASON_ENUM}
					${EL_CURRENCY_ENUM}
					${EL_BOOLEAN_ENUMERATION}*
						${PP_ADDRESS_STATUS_ENUM}
					${PP_PAYMENT_STATUS_ENUM}
					${PP_PAYMENT_PENDING_REASON_ENUM}
					${PP_TRANSACTION_TYPE_ENUM}
					${TL_PICTURE_TYPE_ENUM}
					${EL_IPAPI_CO_JSON_FIELD_ENUM}
					${EROS_ERRORS_ENUM}
					${TL_STRING_ENCODING_ENUM}
					${TL_MUSICBRAINZ_ENUM}
					${EL_HTTP_STATUS_ENUM}
					${TL_FRAME_ID_ENUM}
	]"
end