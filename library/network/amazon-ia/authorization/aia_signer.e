note
	description: "Signs Instant Access HTTP requests using credentials issued by Amazon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	AIA_SIGNER

inherit
	ANY

	EL_MODULE_DATE

	EL_MODULE_DATE_TIME

create
	make

feature {NONE} -- Initialization

	make (a_request: like request; a_credential: like credential)
		do
			make_default
			request := a_request; credential := a_credential
		end

	make_default
		do
			create time_now.make_now_utc
			short_date := time_now.formatted_out (Date_time.ISO_8601.date)
			iso8601_time := Date.ISO_8601_formatted (time_now, False)
		end

feature -- Access

	canonical_request: AIA_CANONICAL_REQUEST
		do
			create Result.make (request, headers_list)
		end

	credential: AIA_CREDENTIAL

	short_date, iso8601_time: STRING

feature -- Basic operations

	sign
		do
			request.headers.set_custom (Header_x_amz_date, iso8601_time)
			request.headers.set_authorization (authorization_header.as_string)
		end

feature {NONE} -- Implementation

	authorization_header: AIA_AUTHORIZATION_HEADER
		do
			create Result.make_signed (Current, canonical_request)
		end

	headers_list: EL_STRING_8_LIST
		do
			Result := Empty_header_list
		end

feature {NONE} -- Internal attributes

	request: FCGI_REQUEST_PARAMETERS

	time_now: DATE_TIME

feature {NONE} -- Constants

	Empty_header_list: EL_STRING_8_LIST
		once
			create Result.make_empty
		end

	Header_x_amz_date: STRING = "x-amz-date"

end