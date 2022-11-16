note
	description: "Verifies Instant Access request as authentic"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	AIA_VERIFIER

inherit
	AIA_SIGNER
		rename
			make as make_signer
		export
			{NONE} sign
		redefine
			headers_list
		end

create
	make

feature -- Access

	elapsed_seconds: INTEGER_64
		-- seconds elapsed since time of request
		-- -1 if `iso8601_time.is_empty'
		local
			request_time: DATE_TIME
		do
			if iso8601_time.is_empty then
				Result := Result.one.opposite
			else
				request_time := Date.from_ISO_8601_formatted (iso8601_time)
				Result := time_now.relative_duration (request_time).seconds_count
			end
		end

feature {NONE} -- Initialization

	make (a_request: like request; credential_list: EL_CHAIN [AIA_CREDENTIAL])
		local
			authorization: STRING
		do
			make_signer (a_request, Default_credential)
			iso8601_time := request.headers.custom (Header_x_amz_date)
			authorization := request.headers.authorization
			if not authorization.is_empty then
				create actual_authorization_header.make_from_string (authorization)
				credential_list.find_first_equal (actual_authorization_header.credential.key, agent {AIA_CREDENTIAL}.public)
				if credential_list.found then
					credential := credential_list.item
				end
			else
				create actual_authorization_header.make
			end
		end

feature -- Status query

	is_verified: BOOLEAN
		do
			if within_time_tolerance then
				Result := authorization_header ~ actual_authorization_header
			end
		end

	within_time_tolerance: BOOLEAN
		-- `True' if less than `Time_tolerance_in_secs' have elapsed since request
		local
			secs: INTEGER_64
		do
			secs := elapsed_seconds
			Result := 0 <= secs and secs <= Time_tolerance_in_secs
		end

feature -- Basic operations

	print_authorization (lio: EL_LOGGABLE)
		local
			lines: EL_STRING_8_LIST
		do
			across << authorization_header, actual_authorization_header >> as header loop
				if header.cursor_index = 1 then
					lio.put_line ("REQUEST AUTHORIZATION")
				else
					lio.put_line ("ACTUAL AUTHORIZATION")
				end
				create lines.make_adjusted_split (header.item.as_string, ',', {EL_STRING_ADJUST}.Left)
				across lines as line loop
					lio.put_line (line.item)
				end
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	headers_list: EL_STRING_8_LIST
		do
			Result := actual_authorization_header.signed_headers_list
		end

feature {NONE} -- Internal attributes

	actual_authorization_header: AIA_AUTHORIZATION_HEADER

feature {NONE} -- Constants

	Default_credential: AIA_CREDENTIAL
		once
			create Result.make_default
		end

	Time_tolerance_in_secs: INTEGER_64
		once
			Result := 15 * 60
		end

end