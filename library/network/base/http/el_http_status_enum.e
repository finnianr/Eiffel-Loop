note
	description: "[
		HTTP status codes. See: [https://en.wikipedia.org/wiki/List_of_HTTP_status_codes]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 17:12:12 GMT (Monday 28th April 2025)"
	revision: "28"

class
	EL_HTTP_STATUS_ENUM

inherit
	EL_TABLE_ENUMERATION_INTEGER_16
		rename
			name_translater as English
		redefine
			initialize, values_in_text
		end

	EL_HTTP_CODE_DESCRIPTIONS
		rename
			code_descriptions as new_table_text
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			redirection_codes := << moved_permanently, moved_temporarily, see_other, temporary_redirect >>
		end

feature -- Access

	redirection_codes: ARRAY [INTEGER_16]

feature -- Status query

	values_in_text: BOOLEAN = True
		-- `True' if enumeration values are found in the `new_table_text' as the first
		-- word of each description.

feature -- 1xx codes

	continue: INTEGER_16
		-- Client can continue.

	switching_protocols: INTEGER_16
		-- The server is switching protocols according to Upgrade header.

feature -- 2xx codes

	accepted: INTEGER_16
		-- Request accepted, but processing not completed.

	created: INTEGER_16
		-- Request succeeded and created a new resource on the server.

	no_content: INTEGER_16
		-- Request succeeded but no content is returned.

	non_authoritative_information: INTEGER_16
		-- Metainformation in header not definitive.

	ok: INTEGER_16
		-- Request succeeded normally.

	partial_content: INTEGER_16
		-- Partial GET request fulfilled.

	reset_content: INTEGER_16
		-- Resquest succeeded. User agent should clear document.

feature -- 3xx codes

	found: INTEGER_16
		-- Resource has been moved temporarily.

	moved_permanently: INTEGER_16
		-- Requested resource assigned new permanent URI.

	moved_temporarily: INTEGER_16
		-- Resource has been moved temporarily. (Name kept for compatibility)
		do
			Result := found
		end

	multiple_choices: INTEGER_16
		-- Requested resource has multiple presentations.

	see_other: INTEGER_16
		-- Response to request can be found under a different URI, and
		--  SHOULD be retrieved using a GET method on that resource.

	temporary_redirect: INTEGER_16
		-- Requested resource resides temporarily under a different URI.

	use_proxy: INTEGER_16
		-- Requested resource MUST be accessed through proxy given by Location field.

feature -- 4xx codes

	bad_request: INTEGER_16
		-- The request could not be understood by the server due to malformed syntax.
		-- The client SHOULD NOT repeat the request without modifications.

	conflict: INTEGER_16
		-- Request could not be completed due to a conflict with current
		--  state of the resource.

	expectation_failed: INTEGER_16
		-- Expectation given in Expect request-header field could not be met.

	failed_dependency: INTEGER_16
		-- Failed Dependency

	forbidden: INTEGER_16
		-- Server understood request, but is refusing to fulfill it.

	gone: INTEGER_16
		-- Requested resource no longer available at server and no
		-- forwarding address is known.

	length_required: INTEGER_16
		-- Server refuses to accept request without a defined Content-Length.

	locked: INTEGER_16
		-- Locked

	method_not_allowed: INTEGER_16
		-- Method in Request-Line not allowed for resource identified by Request-URI.

	not_acceptable: INTEGER_16
		-- Resource identified by request is only capable of generating
		-- response entities which have content characteristics not acceptable
		-- according to accept headers sent in request.

	not_found: INTEGER_16
		-- Resource could not be found.

	not_modified: INTEGER_16
		-- No body, as resource not modified.

	payment_required: INTEGER_16
		-- Reserved for future use.

	precondition_failed: INTEGER_16
		-- Precondition given in one or more of request-header fields
		-- evaluated to false when it was tested on server.

	proxy_authentication_required: INTEGER_16
		-- Client must first authenticate itself with the proxy.

	range_not_satisfiable: INTEGER_16
		-- Range request-header conditions could not be satisfied.

	request_entity_too_large: INTEGER_16
		-- Server is refusing to process a request because request
		-- entity is larger than server is willing or able to process.

	request_time_out: INTEGER_16
		-- Cient did not produce a request within time server prepared to wait.

	request_uri_too_large: INTEGER_16
		-- Server is refusing to service request because Request-URI
		-- is longer than server is willing to interpret.

	retry_with: INTEGER_16
		-- Retry With

	unauthorized: INTEGER_16
		-- Request requires user authentication.

	unordered_collection: INTEGER_16
		-- Unordered Collection

	unprocessable_entity: INTEGER_16
		-- Unprocessable Entity

	unsupported_media_type: INTEGER_16
		-- Unsupported media-type

	upgrade_required: INTEGER_16
		-- Upgrade Required

feature -- 5xx codes

	bad_gateway: INTEGER_16
		-- Server received an invalid response from upstream server

	bandwidth_limit_exceeded: INTEGER_16
		-- Bandwidth Limit Exceeded

	gateway_timeout: INTEGER_16
		-- Server did not receive timely response from upstream server

	http_version_not_supported: INTEGER_16
		-- Server does not support HTTP protocol
		-- version that was used in the request message.

	insufficient_storage: INTEGER_16
		-- Insufficient Storage

	internal_server_error: INTEGER_16
		-- Internal server failure.

	not_extended: INTEGER_16
		-- Not Extended

	not_implemented: INTEGER_16
		-- Server does not support functionality required to service request.

	service_unavailable: INTEGER_16
		-- Server is currently unable to handle request due to
		-- temporary overloading or maintenance of server.

	variant_also_negotiates: INTEGER_16
		-- Variant Also Negotiates

feature {NONE} -- Constants

	English: EL_ENGLISH_NAME_TRANSLATER
		once
			create Result.make
			Result.set_uppercase_exception_set ("http, uri, ok")
		end

end