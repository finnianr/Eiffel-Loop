note
	description: "Http status table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-22 11:51:30 GMT (Monday 22nd July 2024)"
	revision: "1"

class
	HTTP_STATUS_TABLE

inherit
	EL_REFLECTIVE_STRING_TABLE

create
	make_default

feature -- 1xx codes

	continue: EL_SUB [STRING]
		-- Client can continue.

	switching_protocols: EL_SUB [STRING]
		-- The server is switching protocols according to Upgrade header.

feature -- 2xx codes

	accepted: EL_SUB [STRING]
		-- Request accepted, but processing not completed.

	created: EL_SUB [STRING]
		-- Request succeeded and created a new resource on the server.

	no_content: EL_SUB [STRING]
		-- Request succeeded but no content is returned.

	non_authoritative_information: EL_SUB [STRING]
		-- Metainformation in header not definitive.

	ok: EL_SUB [STRING]
		-- Request succeeded normally.

	partial_content: EL_SUB [STRING]
		-- Partial GET request fulfilled.

	reset_content: EL_SUB [STRING]
		-- Resquest succeeded. User agent should clear document.

feature -- 3xx codes

	found: EL_SUB [STRING]
		-- Resource has been moved temporarily.

	moved_permanently: EL_SUB [STRING]
		-- Requested resource assigned new permanent URI.

	moved_temporarily: EL_SUB [STRING]
		-- Resource has been moved temporarily. (Name kept for compatibility)
		do
			Result := found
		end

	multiple_choices: EL_SUB [STRING]
		-- Requested resource has multiple presentations.

	see_other: EL_SUB [STRING]
		-- Response to request can be found under a different URI, and
		--  SHOULD be retrieved using a GET method on that resource.

	temporary_redirect: EL_SUB [STRING]
		-- Requested resource resides temporarily under a different URI.

	use_proxy: EL_SUB [STRING]
		-- Requested resource MUST be accessed through proxy given by Location field.

feature -- 4xx codes

	bad_request: EL_SUB [STRING]
		-- The request could not be understood by the server due to malformed syntax.
		-- The client SHOULD NOT repeat the request without modifications.

	conflict: EL_SUB [STRING]
		-- Request could not be completed due to a conflict with current
		--  state of the resource.

	expectation_failed: EL_SUB [STRING]
		-- Expectation given in Expect request-header field could not be met.

	failed_dependency: EL_SUB [STRING]
		-- Failed Dependency

	forbidden: EL_SUB [STRING]
		-- Server understood request, but is refusing to fulfill it.

	gone: EL_SUB [STRING]
		-- Requested resource no longer available at server and no
		-- forwarding address is known.

	length_required: EL_SUB [STRING]
		-- Server refuses to accept request without a defined Content-Length.

	locked: EL_SUB [STRING]
		-- Locked

	method_not_allowed: EL_SUB [STRING]
		-- Method in Request-Line not allowed for resource identified by Request-URI.

	not_acceptable: EL_SUB [STRING]
		-- Resource identified by request is only capable of generating
		-- response entities which have content characteristics not acceptable
		-- according to accept headers sent in request.

	not_found: EL_SUB [STRING]
		-- Resource could not be found.

	not_modified: EL_SUB [STRING]
		-- No body, as resource not modified.

	payment_required: EL_SUB [STRING]
		-- Reserved for future use.

	precondition_failed: EL_SUB [STRING]
		-- Precondition given in one or more of request-header fields
		-- evaluated to false when it was tested on server.

	proxy_authentication_required: EL_SUB [STRING]
		-- Client must first authenticate itself with the proxy.

	range_not_satisfiable: EL_SUB [STRING]
		-- Range request-header conditions could not be satisfied.

	request_entity_too_large: EL_SUB [STRING]
		-- Server is refusing to process a request because request
		-- entity is larger than server is willing or able to process.

	request_time_out: EL_SUB [STRING]
		-- Cient did not produce a request within time server prepared to wait.

	request_uri_too_large: EL_SUB [STRING]
		-- Server is refusing to service request because Request-URI
		-- is longer than server is willing to interpret.

	retry_with: EL_SUB [STRING]
		-- Retry With

	unauthorized: EL_SUB [STRING]
		-- Request requires user authentication.

	unordered_collection: EL_SUB [STRING]
		-- Unordered Collection

	unprocessable_entity: EL_SUB [STRING]
		-- Unprocessable Entity

	unsupported_media_type: EL_SUB [STRING]
		-- Unsupported media-type

	upgrade_required: EL_SUB [STRING]
		-- Upgrade Required

feature -- 5xx codes

	bad_gateway: EL_SUB [STRING]
		-- Server received an invalid response from upstream server

	bandwidth_limit_exceeded: EL_SUB [STRING]
		-- Bandwidth Limit Exceeded

	gateway_timeout: EL_SUB [STRING]
		-- Server did not receive timely response from upstream server

	http_version_not_supported: EL_SUB [STRING]
		-- Server does not support HTTP protocol
		-- version that was used in the request message.

	insufficient_storage: EL_SUB [STRING]
		-- Insufficient Storage

	internal_server_error: EL_SUB [STRING]
		-- Internal server failure.

	not_extended: EL_SUB [STRING]
		-- Not Extended

	not_implemented: EL_SUB [STRING]
		-- Server does not support functionality required to service request.

	service_unavailable: EL_SUB [STRING]
		-- Server is currently unable to handle request due to
		-- temporary overloading or maintenance of server.

	variant_also_negotiates: EL_SUB [STRING]
		-- Variant Also Negotiates

feature {NONE} -- Implementation

	new_table_text: STRING = "[
		continue:
			100 Client can continue.
		switching_protocols:
			101 The server is switching protocols according to Upgrade header.
		accepted:
			202 Request accepted, but processing not completed.
		ok:
			200 Request succeeded normally.
		created:
			201 Request succeeded and created a new resource on the server.
		non_authoritative_information:
			203 Metainformation in header not definitive.
		no_content:
			204 Request succeeded but no content is returned.
		partial_content:
			206 Partial GET request fulfilled.
		reset_content:
			205 Request succeeded. User agent should clear document.
		found:
			302 Resource has been moved temporarily.
		moved_permanently:
			301 Requested resource assigned new permanent URI.
		multiple_choices:
			300 Requested resource has multiple presentations.
		see_other:
			303 Response to request can be found under a different URI, and
			SHOULD be retrieved using a GET method on that resource.
		temporary_redirect:
			307 Requested resource resides temporarily under a different URI.
		use_proxy:
			305 Requested resource MUST be accessed through proxy given by Location field.
		bad_request:
			400 The request could not be understood by the server due to malformed syntax.
			The client SHOULD NOT repeat the request without modifications.
		conflict:
			409 Request could not be completed due to a conflict with current
			state of the resource.
		expectation_failed:
			417 Expectation given in Expect request-header field could not be met.
		forbidden:
			403 Server understood request, but is refusing to fulfill it.
		gone:
			410 Requested resource no longer available at server and no
			forwarding address is known.
		length_required:
			411 Server refuses to accept request without a defined Content-Length.
		method_not_allowed:
			405 Method in Request-Line not allowed for resource identified by Request-URI.
		not_acceptable:
			406 Resource identified by request is only capable of generating
			response entities which have content characteristics not acceptable
			according to accept headers sent in request.
		not_found:
			404 Resource could not be found.
		not_modified:
			304 No body, as resource not modified.
		payment_required:
			402 Reserved for future use.
		precondition_failed:
			412 Precondition given in one or more of request-header fields
			evaluated to false when it was tested on server.
		proxy_authentication_required:
			407 Client must first authenticate itself with the proxy.
		range_not_satisfiable:
			416 Range request-header conditions could not be satisfied.
		request_entity_too_large:
			413 Server is refusing to process a request because request
			entity is larger than server is willing or able to process.
		request_time_out:
			408 Cient did not produce a request within time server prepared to wait.
		request_uri_too_large:
			414 Server is refusing to service request because Request-URI
			is longer than server is willing to interpret.
		unauthorized:
			401 Request requires user authentication.
		unsupported_media_type:
			415 Unsupported media-type
		unprocessable_entity:
			422 Unprocessable Entity
		locked:
			423 Locked
		failed_dependency:
			424 Failed Dependency
		unordered_collection:
			425 Unordered Collection
		upgrade_required:
			426 Upgrade Required
		retry_with:
			449 Retry With
		bad_gateway:
			502 Server received an invalid response from upstream server
		gateway_timeout:
			504 Server did not receive timely response from upstream server
		http_version_not_supported:
			505 Server does not support HTTP protocol version that was used in the request message.
		internal_server_error:
			500 Internal server failure.
		not_implemented:
			501 Server does not support functionality required to service request.
		service_unavailable:
			503 Server is currently unable to handle request due to temporary overloading
			or maintenance of server.
		variant_also_negotiates:
			506 Variant also negotiates
		insufficient_storage:
			507 Insufficient Storage
		bandwidth_limit_exceeded:
			509 Bandwidth limit exceeded
		not_extended:
			510 Not extended
	]"

end