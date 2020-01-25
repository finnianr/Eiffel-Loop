note
	description: "Request formatted in a standard (canonical) form for hashing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 4:14:32 GMT (Saturday 25th January 2020)"
	revision: "12"

class
	AIA_CANONICAL_REQUEST

inherit
	EL_STRING_8_LIST
		rename
			make as make_count
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

	EL_MODULE_DIGEST

create
	make

feature {NONE} -- Initialization

	make (request: FCGI_REQUEST_PARAMETERS; headers_list: EL_SPLIT_STRING_LIST [STRING])
		local
			headers: HASH_TABLE [ZSTRING, STRING]
		do
			if headers_list.is_empty then
				headers := request.headers.as_table (True)
			else
				headers := request.headers.selected (headers_list)
			end
			make_count (headers.count + 6)
			extend (request.request_method)
			extend (request.full_request_url)
			extend (Empty_string_8) -- the Java SDK does not add the query string to the canonical form

			create sorted_header_names.make_from_array (headers.current_keys)
			sorted_header_names.sort

			across sorted_header_names as name loop
				extend (canonical_nvp (name.item, headers [name.item]))
			end

			extend (Empty_string_8) -- the Java SDK adds an empty line after the headers
			extend (sorted_header_names.joined (';'))
			extend (Digest.sha_256 (request.content).to_hex_string); last.to_lower
		end

feature -- Access

	sha_256_digest: EL_DIGEST_ARRAY
		local
			sha: EL_SHA_256
		do
			create sha.make
			-- Signer.java converts strings to `DEFAULT_ENCODING' which is UTF-8
			-- md.update(text.getBytes(DEFAULT_ENCODING));
			sha.enable_utf_8_mode

			sha.sink_joined_strings (Current, '%N')
			create Result.make_final (sha)
		end

	sorted_header_names: EL_STRING_8_LIST

feature {NONE} -- Implementation

	canonical_nvp (name: STRING; value: ZSTRING): ZSTRING
		do
			create Result.make (name.count + value.count + 1)
			Result.append_string_general (name)
			Result.append_character (':')
			if value.is_left_adjustable or else value.is_right_adjustable or else not value.is_canonically_spaced then
				Result.append (value.as_canonically_spaced)
			else
				Result.append (value)
			end
		end
end
