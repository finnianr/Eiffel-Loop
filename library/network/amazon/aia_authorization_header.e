note
	description: "Authorization header for authentication"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 16:02:27 GMT (Friday 10th November 2017)"
	revision: "1"

class
	AIA_AUTHORIZATION_HEADER

inherit
	EL_REFLECTIVELY_SETTABLE [STRING]
		rename
			make_default as make,
			name_adaptation as from_camel_case
		redefine
			Default_values_by_type, is_equal
		end

	EL_SHARED_ONCE_STRINGS
		undefine
			is_equal
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

	EL_MODULE_DIGEST
		undefine
			is_equal
		end

create
	make, make_from_string, make_signed

feature {NONE} -- Initialization

	make_from_string (str: STRING)
		local
			modified: STRING; fields: EL_STRING_8_LIST
		do
			make
			modified := empty_once_string_8
			-- Tweak `str' to make it splittable as series of assignments
			modified.append (Algorithm_equals); modified.append (str)
			modified.insert_character (',', modified.index_of (' ', Algorithm_equals.count))
			create fields.make_with_separator (modified, ',', True)
			across fields as assignment loop
				set_field_from_nvp (assignment.item, once "=")
			end
		end

	make_signed (signer: AIA_SIGNER; canonical_request: AIA_CANONICAL_REQUEST)
		-- make signed header
		local
			hmac: EL_HMAC_SHA_256; string_to_sign, header_list: EL_STRING_LIST [STRING]
		do
			make
			algorithm := Default_algorithm
			create header_list.make_from_array (canonical_request.sorted_header_list.key_list.to_array)
			signed_headers := header_list.joined (Semicolon [1])

			create string_to_sign.make_from_array (<<
				algorithm, signer.iso8601_time, Empty_string_8,
				canonical_request.sha_256_digest.to_hex_string
			>>)

			create hmac.make (signer.credential.daily_secret (signer.short_date))
			hmac.sink_string (string_to_sign.joined_lines)
			hmac.finish
			signature := hmac.digest.to_hex_string
			credential.set_key (signer.credential.public)
			credential.set_date (signer.short_date)
		end

feature -- Access

	algorithm: STRING

	credential: AIA_CREDENTIAL_ID

	signature: STRING

	signed_headers: STRING

	signed_headers_list: EL_SPLIT_ZSTRING_LIST
		do
			create Result.make (signed_headers, Semicolon)
		end

	as_string: STRING
		local
			template: like Signed_string_template
		do
			template := Signed_string_template
			template.wipe_out_variables
			template.set_variables_from_object (Current)
			template.set_variables_from_object (credential)
			Result := template.substituted
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := algorithm ~ other.algorithm
				and credential ~ other.credential
				and signature ~ other.signature
				and signed_headers ~ other.signed_headers
		end

feature {NONE} -- Constants

	Algorithm_equals: STRING = "algorithm="

	Default_algorithm: STRING_8
		once
			Result := "DTA1-HMAC-SHA256"
		end

	Default_values_by_type: EL_HASH_TABLE [ANY, INTEGER]
		once
			Result := Precursor
			Result [({AIA_CREDENTIAL_ID}).type_id] := create {AIA_CREDENTIAL_ID}.make_default
		end

feature {NONE} -- Constants

	Semicolon: ZSTRING
		once
			Result := ";"
		end

	Signed_string_template: EL_SUBSTITUTION_TEMPLATE [STRING]
		once
			create Result.make ("$algorithm SignedHeaders=$signed_headers, Credential=$key/$date, Signature=$signature")
		end
end
