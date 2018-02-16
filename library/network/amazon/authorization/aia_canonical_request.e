note
	description: "Request formatted in a standard (canonical) form for hashing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-01 9:48:39 GMT (Thursday 1st February 2018)"
	revision: "3"

class
	AIA_CANONICAL_REQUEST

inherit
	ARRAYED_LIST [ZSTRING]
		rename
			make as make_count
		export
			{NONE} all
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal, copy
		end

	EL_MODULE_DIGEST
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (request: FCGI_REQUEST_PARAMETERS; headers_list: EL_SPLIT_STRING_LIST [STRING])
		local
			header_key_list: EL_STRING_8_LIST; l_digest, value: ZSTRING
			headers: HASH_TABLE [ZSTRING, STRING]
		do
			if headers_list.is_empty then
				headers := request.headers.as_table (True)
			else
				headers := request.headers.selected (headers_list)
			end
			make_from_array (<<
				request.request_method,
				request.full_request_url,
				Empty_string -- the Java SDK does not add the query string to the canonical form
			>>)
			create sorted_header_list.make_from_table (headers)
			from sorted_header_list.start until sorted_header_list.after loop
				value := sorted_header_list.item_value
				if value.is_left_adjustable or else value.is_right_adjustable or else not value.is_canonically_spaced then
					value := value.as_canonically_spaced
					value.trim
					sorted_header_list.item.value := value
				end
				sorted_header_list.forth
			end

			sorted_header_list.sort
			append (sorted_header_list.as_string_list (agent colon_join))
			extend (Empty_string) -- the Java SDK adds an empty line after the headers

			create header_key_list.make_from_array (sorted_header_list.key_list.to_array)
			extend (header_key_list.joined (';'))

			l_digest := Digest.sha_256 (request.content).to_hex_string
			l_digest.to_lower
			extend (l_digest)
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
			create Result.make_final_sha_256 (sha)
		end

	sorted_header_list: EL_SORTABLE_ARRAYED_MAP_LIST [STRING, ZSTRING]

	sorted_header_names: EL_STRING_LIST [STRING]
		do
			create Result.make_from_array (sorted_header_list.key_list.to_array)
		end

feature {NONE} -- Implementation

	colon_join (name: STRING; value: ZSTRING): ZSTRING
		do
			create Result.make (name.count + value.count + 1)
			Result.append_string_general (name)
			Result.append_character (':')
			Result.append (value)
		end
end
