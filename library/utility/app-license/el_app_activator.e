note
	description: "App activator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_APP_ACTIVATOR

inherit
	ANY

	EL_MODULE_BASE_64

	EL_MODULE_ENCRYPTION

	EL_MODULE_ENVIRONMENT

	EL_MODULE_MACHINE_ID

	EL_MODULE_RSA

create
	make

feature {NONE} -- Initiliazation

	make (registration_name: STRING; private_key_path: FILE_PATH; private_key_encrypter: EL_AES_ENCRYPTER)
			--
		local
			private_key: EL_RSA_PRIVATE_KEY; user_machine_md5: EL_MD5_128
		do
			create private_key.make_from_pkcs1_file (private_key_path, private_key_encrypter)

			create user_machine_md5.make_copy (Machine_id.md5)
			user_machine_md5.sink_string (registration_name)
			create user_cpu_digest.make_from_bytes (user_machine_md5.digest, 0, 15)

			signature := private_key.sign (user_cpu_digest)
			create activation_key.make (registration_name, Base_64.encoded_special (signature.as_bytes))
		end

feature -- Access

	user_cpu_digest: INTEGER_X

	signature: INTEGER_X

feature -- Status query

	verify (public_key: EL_RSA_PUBLIC_KEY): BOOLEAN
		do
			Result := public_key.verify (user_cpu_digest, signature)
		end

feature -- Access

	activation_key: EL_APP_ACTIVATION_KEY

end