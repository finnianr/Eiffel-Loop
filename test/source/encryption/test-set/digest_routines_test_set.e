note
	description: "Digest routines test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 10:23:56 GMT (Friday 14th February 2020)"
	revision: "6"

class
	DIGEST_ROUTINES_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIGEST

	EL_MODULE_LIO

	EL_MODULE_STRING_8

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("hmac_sha_256_digest",	agent test_hmac_sha_256_digest)
			eval.call ("sha_256_digest", 			agent test_sha_256_digest)
			eval.call ("rfc_4231_2_ascii",	 	agent test_rfc_4231_2_ascii)
			eval.call ("reset",						agent test_reset)
		end

feature -- Tests

	test_sha_256_digest
		local
			l_digest: STRING
		do
			l_digest := "ECCA0DFB08ED1972A03B832A901BC550DCAC1944F910FDEE4F15199B0C688B6A" -- From PHP
			assert ("correct sha_256", l_digest ~ Digest.sha_256 (Price_string.to_utf_8).to_hex_string)
		end

	test_hmac_sha_256_digest
		note
			testing:	"covers/{EL_HMAC_SHA_256}.sink_joined_strings"
		local
			l_digest: STRING
			hmac: EL_HMAC_SHA_256; string_list: EL_STRING_8_LIST
		do
			l_digest := "485858AB7045C7D390FA7CEFE0F4854ECB46BA5D9A3866AE570DF70CB884285D" -- From Python run/hmac_test.py

			lio.put_labeled_string ("Digest", Digest.hmac_sha_256 (Price_string.to_utf_8, Secret_key).to_hex_string)
			lio.put_new_line
			assert ("correct hmac_sha_256", l_digest ~ Digest.hmac_sha_256 (Price_string.to_utf_8, Secret_key).to_hex_string)

			create string_list.make_with_lines ("[
				one
				two
				three
			]")
			create hmac.make_ascii_key (Secret_key)
			hmac.sink_joined_strings (string_list, '%N')
			hmac.finish
			l_digest := "89F3A4B277DC954756D3C19C66A162F7881EF7EBB6508532B7A28EFF94BECCCE" -- From Python run/hmac_test.py
			assert ("digest.to_hex_string OK", hmac.digest.to_hex_string ~ l_digest)
		end

	test_rfc_4231_2_ascii
		-- original test to identify `{HMAC}.reset' problem
		local
			hmac: HMAC_SHA256; expected: INTEGER_X
		do
			create hmac.make_ascii_key ("Jefe")
--			hmac.reset This line causes the test to fail
			hmac.sink_string ("what do ya want for nothing?")
			hmac.finish
			create expected.make_from_hex_string ("5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843")
			assert ("test_rfc_4231_2", hmac.hmac ~ expected)
		end

	test_reset
		note
			testing: "covers/{EL_MD5_128}.reset, covers/{EL_SHA_256}.reset, covers/{EL_HMAC_SHA_256}.reset"
		local
			l_digest: EL_DIGEST_ARRAY
		do
			assert ("same result", Digest.md5 (Price_string_utf_8) ~ Digest.md5 (Price_string_utf_8))
			assert ("same result", Digest.sha_256 (Price_string_utf_8) ~ Digest.sha_256 (Price_string_utf_8))
			l_digest := Digest.hmac_sha_256 (Price_string_utf_8, Secret_key)
			assert ("same result", l_digest ~ Digest.hmac_sha_256 (Price_string_utf_8, Secret_key))
		end

feature {NONE} -- Constants

	Price_string_utf_8: STRING
		once
			Result := Price_string.to_utf_8
		end

	Price_string: ZSTRING
		once
			Result := {STRING_32} "€ 100"
		end

	Secret_key: STRING = "secret"
end
