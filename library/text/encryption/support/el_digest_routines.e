note
	description: "Digest routines accessible via [$source EL_MODULE_DIGEST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 16:10:18 GMT (Monday 1st January 2024)"
	revision: "13"

class
	EL_DIGEST_ROUTINES

inherit
	UUID_GENERATOR
		export
			{NONE} all
		end

	EL_SHARED_DIGESTS
		rename
			Sha_256 as Digest_sha_256
		end

	EL_MODULE_FILE

feature -- Access

	new_salted (phrase_utf_8: STRING_8; salt_data: SPECIAL [NATURAL_8]): SPECIAL [NATURAL_8]
		-- salted digest of `phrase_utf_8'
		local
			l_md5: MD5; sha: SHA256; md5_hash, data, phrase_data: SPECIAL [NATURAL_8]
			i, j: INTEGER; s: EL_STRING_8_ROUTINES
		do
			create sha.make
			create Result.make_filled (1, 32)
			create l_md5.make
			create md5_hash.make_filled (1, 16)
			phrase_data := s.to_code_array (phrase_utf_8)
			from i := 0 until i > 50 loop
				if i \\ 2 = 0 then
					data := phrase_data
				else
					data := salt_data
				end
				if data.count > 0 then
					j := i \\ data.count
					if data [j] \\ 2 = 0 then
						l_md5.sink_special (data, 0, data.count - 1)
					else
						sha.sink_special (data, 0, data.count - 1)
					end
				end
				i := i + 1
			end
			sha.do_final (Result, 0)
			l_md5.do_final (md5_hash, 0)
			-- Merge hashes
			from i := 0 until i = md5_hash.count loop
				Result [i * 2] := Result.item (i * 2).bit_xor (md5_hash [i])
				i := i + 1
			end
		end

	new_random_salt: SPECIAL [NATURAL_8]
		local
			i: INTEGER
		do
			create Result.make_empty (Salt_count)
			from i := 0 until i = Result.capacity loop
				Result.extend (rand_byte)
				i := i + 1
			end
		end

feature -- Digests

	hmac_sha_256 (string, secret_key: STRING): EL_DIGEST_ARRAY
			--
		do
			create Result.make_sink (Hmac_sha_256_table.item (secret_key), string)
		end

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

	md5_raw_data (path: FILE_PATH): EL_DIGEST_ARRAY
			--
		do
			create Result.make_from_memory (MD5_128, File.data (path))
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

feature -- Constants

	Salt_count: INTEGER = 24

end