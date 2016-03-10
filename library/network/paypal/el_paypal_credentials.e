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
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 16:31:45 GMT (Sunday 20th December 2015)"
	revision: "6"

class
	EL_PAYPAL_CREDENTIALS

inherit
	EL_HTTP_NAME_VALUE_PARAMETER_LIST
		rename
			make as make_list
		end

create
	make

feature {NONE} -- Initialization

	make (credentials_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER)
		do
			make_list (3)
			-- Assumes AES 128 bit chain block encryption
			extend_from_file (create {EL_ENCRYPTED_FILE_LINE_SOURCE}.make (credentials_path, encrypter))
		ensure
			valid_entries: across << Var_user, Var_password, Var_signature >> as name all has_parameter (name.item) end
		end

feature -- Contract Support

	has_parameter (name: ZSTRING): BOOLEAN
		do
			find_first (name, agent {like item}.name)
			Result := not exhausted
		end

feature {NONE} -- Constants

	Var_password: ZSTRING
		once
			Result := "PWD"
		end

	Var_signature: ZSTRING
		once
			Result := "SIGNATURE"
		end

	Var_user: ZSTRING
		once
			Result := "USER"
		end

end
