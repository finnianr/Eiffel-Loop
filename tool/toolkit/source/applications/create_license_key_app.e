note
	description: "Summary description for {CREATE_LICENSE_KEY_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:20 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	CREATE_LICENSE_KEY_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_TESTABLE_APPLICATION

	EL_MODULE_BASE_64

	EL_MODULE_ENVIRONMENT

	EL_MODULE_ENCRYPTION

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			Args.set_string_from_word_option ("d", agent set_output_dir, "")
			Args.set_string_from_word_option ("reg", agent set_registration_name, "")
			Args.set_string_from_word_option ("private_key", agent set_private_key_path, "")
		end

feature -- Basic operations

	normal_run
			--
		do
			log.enter ("run")
			create activator.make (registration_name, private_key_path)

			log.put_string_field ("USER CPU DIGEST", Base_64.encoded_special (activator.user_cpu_digest.as_bytes))
			log.put_integer_field (" (bits", activator.user_cpu_digest.bits); log.put_character (')')
			log.put_new_line

			log.put_string_field ("SIGNATURE", activator.activation_key.value)
			log.put_integer_field (" (bits", activator.signature.bits); log.put_character (')')
			log.put_new_line

			activator.activation_key.save_as_xml (output_dir + "licensed.xml")

			log.exit
		end

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("rsa_keys", agent test_rsa_key_pair_1, 1641089377)
			Test.do_file_tree_test ("rsa_keys", agent test_rsa_key_pair_2, 3142751471)
		end

	test_rsa_key_pair_1 (dir_path: EL_DIR_PATH)
			--
		local
			public: EL_STORABLE_RSA_PUBLIC_KEY
			correct: BOOLEAN
		do
			log.enter ("test_rsa_key_pair_1")
			output_dir := dir_path
			registration_name :=  "Finnian Reilly"
			private_key_path := dir_path + "rsa.private-key.1.xml"

			normal_run

			create public.make_from_file (dir_path + "rsa.public-key.1.xml")

			correct := public.verify_base64 (activator.user_cpu_digest, "XcBWLldBgNaHgr2ZYkV0TtGo3yxTYcUoDfbSI/sbgKg=")

			log.put_new_line
			log.put_string ("IS VALID SIGNATURE?: ")
			log.put_boolean (correct)
			log.put_new_line
			log.exit
		end

	test_rsa_key_pair_2 (dir_path: EL_DIR_PATH)
			--
		local
			public: EL_RSA_PUBLIC_KEY
			correct: BOOLEAN
		do
			log.enter ("test_rsa_key_pair_2")
			output_dir := dir_path
			registration_name :=  "Finnian Reilly"
			private_key_path := dir_path + "rsa.private-key.2.xml"

			normal_run

			create public.make_from_array (Public_key_2)

			correct := activator.user_cpu_digest ~ public.encrypt_base64 ("gkAc178hxBJbcTtDq6wpScpTW3C/OLng8TzYTPF2Jl4=")

			log.put_new_line
			log.put_string ("SIGNATURE IS VALID: ")
			log.put_boolean (correct)
			log.put_new_line
			log.exit
		end

feature -- Element change

	set_output_dir (a_output_dir: EL_ASTRING)
			--
		do
			output_dir := a_output_dir
		end

	set_registration_name (a_registration_name: EL_ASTRING)
			--
		do
			registration_name := a_registration_name
		end

	set_private_key_path (a_private_key_path: EL_ASTRING)
			--
		do
			private_key_path := a_private_key_path
		end

feature {NONE} -- Implementation

	output_dir: EL_DIR_PATH

	cpu_model: STRING
		do
			Result := Environment.Operating.CPU_model_name
		end

	registration_name: EL_ASTRING

	private_key_path: EL_FILE_PATH

	activator: EL_APP_ACTIVATOR

feature {NONE} -- Constants

	Public_key_2: ARRAY [NATURAL_8]
			--
		once
			Result :=  <<
				148, 205, 244, 213, 1, 41, 236, 146, 247, 135, 188, 131, 80, 210, 3, 190, 230, 130, 201, 72, 196, 147,
				191, 135, 36, 110, 18, 213, 31, 9, 28, 133
			>>
		end

	Option_name: STRING = "create_license_key"

	Description: STRING = "Create a license key"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{CREATE_LICENSE_KEY_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{EL_RSA_KEY_PAIR}, "*"]
			>>
		end


end