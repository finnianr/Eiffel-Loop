note
	description: "API configuration"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-27 14:32:02 GMT (Tuesday 27th August 2019)"
	revision: "2"

class
	PP_CONFIGURATION

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS

	EL_SHARED_SINGLETONS

create
	make

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH; a_decrypter: like decrypter)
		do
			put_singleton (Current)
			decrypter := a_decrypter
			make_from_file (path)
		end

feature -- Access

	account_id: STRING
		-- Paypal API account id

	api_url: ZSTRING

	cert_authority_info_path: EL_FILE_PATH

	credentials_path: EL_FILE_PATH

	domain_name: STRING

	decrypter: EL_AES_ENCRYPTER
		-- credentials decrypter

	notify_url: STRING

	receiver_email: STRING

	validation_url: STRING

feature -- Status query

	is_sandbox: BOOLEAN
		-- True if operating in Paypal testing sandbox

feature -- Factory

	new_credentials: PP_CREDENTIALS
		do
			create Result.make (credentials_path, decrypter)
		end

feature {NONE} -- Implementation

	register_default_values
		once
		end

note
	notes: "[
		Create an instance of this class first before accessing {[$source PP_SHARED_API_CONNECTION]}.API_connection

		**Example Configuration File**

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			pp_configuration:
				is_sandbox = true
				cert_authority_info_path = "$HOME/Documents/Certificates/cacert.pem"
				domain_name = "www.sandbox.paypal.com"

				account_id = ALDKM1CSCFFXJ
				api_url = "https://api-3t.sandbox.paypal.com/nvp"
				credentials_path = "$HOME/Documents/Certificates/sandbox-paypal.text.aes"
				notify_url = "http://sandbox.myching.software/IPN/listener"

				# Instant Payment Notification
				receiver_email = "john-facilitator@widgets.com"
				validation_url = "https://ipnpb.sandbox.paypal.com/cgi-bin/webscr"
	]"
end
