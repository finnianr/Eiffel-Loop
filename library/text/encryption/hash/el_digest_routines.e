note
	description: "Digest routines accessible via [$source EL_MODULE_DIGEST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 5:59:39 GMT (Monday 7th February 2022)"
	revision: "9"

class
	EL_DIGEST_ROUTINES

inherit
	ANY

	EL_SHARED_DIGESTS
		rename
			Sha_256 as Digest_sha_256
		end

	EL_MODULE_FILE

feature -- Digests

	md5 (string: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (MD5_128, string)
		end

	md5_plain_text (path: FILE_PATH): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (MD5_128, File.plain_text (path))
		end

	hmac_sha_256 (string, secret_key: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (Hmac_sha_256_table.item (secret_key), string)
		end

	sha_256 (string: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (Digest_sha_256, string)
		end

	sha_256_file (path: FILE_PATH): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (Digest_sha_256, File.plain_text (path))
		end

end