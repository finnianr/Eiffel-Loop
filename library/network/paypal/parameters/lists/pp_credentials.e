note
	description: "[
		Reads name value pairs from file encrypted using EL utility program: el_toolkit -crypto
		
		Example:
		
			# This is a comment
			
			USER: finnian
			SIGNATURE: A87F87C8789-AF89AA
			PWD: dragon-legend1
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 8:41:09 GMT (Tuesday 24th April 2018)"
	revision: "7"

class
	PP_CREDENTIALS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_string_or_expanded_field,
			import_name as from_upper_snake_case,
			export_name as to_upper_snake_case
		end

	EL_SETTABLE_FROM_ZSTRING

create
	make

feature {NONE} -- Initialization

	make (credentials_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER)
		local
			lines: EL_ENCRYPTED_FILE_LINE_SOURCE
		do
			make_default
			create lines.make (credentials_path, encrypter)
			set_from_lines (lines, ':', agent is_comment)
			lines.close
			create http_parameters.make_from_object (Current)
		ensure
			no_empty_field: not (<< user, pwd, signature >>).there_exists (agent {EL_ZSTRING}.is_empty)
		end

feature -- Access

	http_parameters: EL_HTTP_NAME_VALUE_PARAMETER_LIST

	pwd: ZSTRING

	signature: ZSTRING

	user: ZSTRING

feature {NONE} -- Implementation

	is_comment (str: ZSTRING): BOOLEAN
		do
			Result := not str.is_empty and then str [1] = '#'
		end

end
