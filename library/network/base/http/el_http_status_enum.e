note
	description: "[
		HTTP status codes. See: [https://en.wikipedia.org/wiki/List_of_HTTP_status_codes]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 12:41:36 GMT (Monday 23rd April 2018)"
	revision: "7"

class
	EL_HTTP_STATUS_ENUM

inherit
	EL_ENUMERATION [NATURAL_16]
		rename
			export_name as to_english,
			import_name as import_default
		redefine
			initialize_fields, export_to_english
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			continue := 100
			switching_protocols := 101

			ok := 200
			created := 201
			accepted := 202
			non_authoritative_information := 203
			no_content := 204
			reset_content := 205
			partial_content := 206

			multiple_choices := 300
			moved_permanently := 301
			found := 302
			see_other := 303
			use_proxy := 305
			temporary_redirect := 307

			bad_request := 400
			unauthorized := 401
			payment_required := 402
			forbidden := 403
			not_found := 404
			method_not_allowed := 405
			not_acceptable := 406
			proxy_authentication_required := 407
			request_time_out := 408
			not_modified := 304
			conflict := 409
			gone := 410
			length_required := 411
			precondition_failed := 412
			request_entity_too_large := 413
			request_uri_too_large := 414
			unsupported_media_type := 415
			range_not_satisfiable := 416
			expectation_failed := 417

			internal_server_error := 500
			not_implemented := 501
			bad_gateway := 502
			service_unavailable := 503
			gateway_timeout := 504
			http_version_not_supported := 505
		end

feature -- 1xx codes

	continue: NATURAL_16
		-- Client can continue.

	switching_protocols: NATURAL_16
		-- The server is switching protocols according to Upgrade header.

feature -- 2xx codes

	accepted: NATURAL_16
		-- Request accepted, but processing not completed.

	ok: NATURAL_16
		-- Request succeeded normally.

	created: NATURAL_16
		-- Request succeeded and created a new resource on the server.

	non_authoritative_information: NATURAL_16
		-- Metainformation in header not definitive.

	no_content: NATURAL_16
		-- Request succeeded but no content is returned.

	partial_content: NATURAL_16
		-- Partial GET request fulfilled.

	reset_content: NATURAL_16
		-- Resquest succeeded. User agent should clear document.


feature -- 3xx codes

	found: NATURAL_16
		-- Resource has been moved temporarily.

	moved_permanently: NATURAL_16
		-- Requested resource assigned new permanent URI.

	moved_temporarily: NATURAL_16
		-- Resource has been moved temporarily. (Name kept for compatibility)
		do
			Result := found
		end

	multiple_choices: NATURAL_16
		-- Requested resource has multiple presentations.

	see_other: NATURAL_16
		-- Response to request can be found under a different URI, and
		--  SHOULD be retrieved using a GET method on that resource.

	temporary_redirect: NATURAL_16
		-- Requested resource resides temporarily under a different URI.


	use_proxy: NATURAL_16
		-- Requested resource MUST be accessed through proxy given by Location field.

feature -- 4xx codes

	bad_request: NATURAL_16
		-- The request could not be understood by the server due to malformed syntax.
		-- The client SHOULD NOT repeat the request without modifications.

	conflict: NATURAL_16
		-- Request could not be completed due to a conflict with current
		--  state of the resource.

	expectation_failed: NATURAL_16
		-- Expectation given in Expect request-header field could not be met.

	forbidden: NATURAL_16
		-- Server understood request, but is refusing to fulfill it.

	gone: NATURAL_16
		-- Requested resource no longer available at server and no
		--  forwarding address is known.

	length_required: NATURAL_16
		-- Server refuses to accept request without a defined Content-Length.

	method_not_allowed: NATURAL_16
		-- Method in Request-Line not allowed for resource identified by Request-URI.

	not_acceptable: NATURAL_16
		-- Resource identified by request is only capable of generating
		-- response entities which have content characteristics not acceptable
		-- according to accept headers sent in request.

	not_found: NATURAL_16
		-- Resource could not be found.

	not_modified: NATURAL_16
		-- No body, as resource not modified.

	payment_required: NATURAL_16
		-- Reserved for future use.

	precondition_failed: NATURAL_16
		-- Precondition given in one or more of request-header fields
		-- evaluated to false when it was tested on server.

	proxy_authentication_required: NATURAL_16
		-- Client must first authenticate itself with the proxy.

	range_not_satisfiable: NATURAL_16
		-- Range request-header conditions could not be satisfied.

	request_entity_too_large: NATURAL_16
		-- Server is refusing to process a request because request
		--  entity is larger than server is willing or able to process.

	request_time_out: NATURAL_16
		-- Cient did not produce a request within time server prepared to wait.

	request_uri_too_large: NATURAL_16
		-- Server is refusing to service request because Request-URI
		--  is longer than server is willing to interpret.

	unauthorized: NATURAL_16
		-- Request requires user authentication.

	unsupported_media_type: NATURAL_16
		-- Unsupported media-type

feature -- 5xx codes

	bad_gateway: NATURAL_16
		-- Server received an invalid response from upstream server

	gateway_timeout: NATURAL_16
		-- Server did not receive timely response from upstream server

	http_version_not_supported: NATURAL_16
		-- Server does not support HTTP protocol
		--  version that was used in the request message.

	internal_server_error: NATURAL_16
		-- Internal server failure.

	not_implemented: NATURAL_16
		-- Server does not support functionality required to service request.

	service_unavailable: NATURAL_16
		-- Server is currently unable to handle request due to
		-- temporary overloading or maintenance of server.

feature {NONE} -- Implementation

	export_to_english (name_in, english_out: STRING)
		do
			Naming.to_english (name_in, english_out, Upper_case_words)
		end

feature {NONE} -- Constants

	Upper_case_words: ARRAY [STRING]
		once
			Result := << "http", "uri", "ok" >>
		end
end
