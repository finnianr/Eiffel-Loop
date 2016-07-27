note
	description: "Summary description for {EL_APP_ACTIVATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-21 11:21:01 GMT (Tuesday 21st June 2016)"
	revision: "4"

class
	EL_APP_ACTIVATOR

inherit
	EL_MODULE_BASE_64

	EL_MODULE_ENCRYPTION

	EL_MODULE_ENVIRONMENT

create
	make

feature {NONE} -- Initiliazation

	make (registration_name: STRING; private_key_path: EL_FILE_PATH)
			--
		local
			key_reader: EL_X509_CERTIFICATE_READER_COMMAND_I
--			private: EL_STORABLE_RSA_PRIVATE_KEY
			user_cpu_source: STRING
		do

			create private.make_from_file (private_key_path)

			user_cpu_source := registration_name + " " + Environment.Operating.CPU_model_name
			create user_cpu_digest.make_from_bytes (Encryption.md5_digest_16 (user_cpu_source), 0, 15)

			signature := private.sign (user_cpu_digest)
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