note
	description: "Http status table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 9:47:58 GMT (Saturday 5th April 2025)"
	revision: "5"

class
	HTTP_STATUS_TABLE

inherit
	EL_REFLECTIVE_STRING_TABLE

	EL_OBJECT_PROPERTY_I

create
	make_default

feature -- Measurement

	text_manifest_size: INTEGER
		do
			Result := property (new_table_text).deep_physical_size
		end

feature -- 1xx codes

	continue: like ok
		-- Client can continue.

	switching_protocols: like ok
		-- The server is switching protocols according to Upgrade header.

feature -- 2xx codes

	accepted: like ok
		-- Request accepted, but processing not completed.

	created: like ok
		-- Request succeeded and created a new resource on the server.

	no_content: like ok
		-- Request succeeded but no content is returned.

	non_authoritative_information: like ok
		-- Metainformation in header not definitive.

	ok: EL_SUBSTRING_8
		-- Request succeeded normally.

	partial_content: like ok
		-- Partial GET request fulfilled.

	reset_content: like ok
		-- Resquest succeeded. User agent should clear document.

feature -- 3xx codes

	found: like ok
		-- Resource has been moved temporarily.

	moved_permanently: like ok
		-- Requested resource assigned new permanent URI.

	moved_temporarily: like ok
		-- Resource has been moved temporarily. (Name kept for compatibility)
		do
			Result := found
		end

	multiple_choices: like ok
		-- Requested resource has multiple presentations.

	see_other: like ok
		-- Response to request can be found under a different URI, and
		--  SHOULD be retrieved using a GET method on that resource.

	temporary_redirect: like ok
		-- Requested resource resides temporarily under a different URI.

	use_proxy: like ok
		-- Requested resource MUST be accessed through proxy given by Location field.

feature -- 4xx codes

	bad_request: like ok
		-- The request could not be understood by the server due to malformed syntax.
		-- The client SHOULD NOT repeat the request without modifications.

	conflict: like ok
		-- Request could not be completed due to a conflict with current
		--  state of the resource.

	expectation_failed: like ok
		-- Expectation given in Expect request-header field could not be met.

	failed_dependency: like ok
		-- Failed Dependency

	forbidden: like ok
		-- Server understood request, but is refusing to fulfill it.

	gone: like ok
		-- Requested resource no longer available at server and no
		-- forwarding address is known.

	length_required: like ok
		-- Server refuses to accept request without a defined Content-Length.

	locked: like ok
		-- Locked

	method_not_allowed: like ok
		-- Method in Request-Line not allowed for resource identified by Request-URI.

	not_acceptable: like ok
		-- Resource identified by request is only capable of generating
		-- response entities which have content characteristics not acceptable
		-- according to accept headers sent in request.

	not_found: like ok
		-- Resource could not be found.

	not_modified: like ok
		-- No body, as resource not modified.

	payment_required: like ok
		-- Reserved for future use.

	precondition_failed: like ok
		-- Precondition given in one or more of request-header fields
		-- evaluated to false when it was tested on server.

	proxy_authentication_required: like ok
		-- Client must first authenticate itself with the proxy.

	range_not_satisfiable: like ok
		-- Range request-header conditions could not be satisfied.

	request_entity_too_large: like ok
		-- Server is refusing to process a request because request
		-- entity is larger than server is willing or able to process.

	request_time_out: like ok
		-- Cient did not produce a request within time server prepared to wait.

	request_uri_too_large: like ok
		-- Server is refusing to service request because Request-URI
		-- is longer than server is willing to interpret.

	retry_with: like ok
		-- Retry With

	unauthorized: like ok
		-- Request requires user authentication.

	unordered_collection: like ok
		-- Unordered Collection

	unprocessable_entity: like ok
		-- Unprocessable Entity

	unsupported_media_type: like ok
		-- Unsupported media-type

	upgrade_required: like ok
		-- Upgrade Required

feature -- 5xx codes

	bad_gateway: like ok
		-- Server received an invalid response from upstream server

	bandwidth_limit_exceeded: like ok
		-- Bandwidth Limit Exceeded

	gateway_timeout: like ok
		-- Server did not receive timely response from upstream server

	http_version_not_supported: like ok
		-- Server does not support HTTP protocol
		-- version that was used in the request message.

	insufficient_storage: like ok
		-- Insufficient Storage

	internal_server_error: like ok
		-- Internal server failure.

	not_extended: like ok
		-- Not Extended

	not_implemented: like ok
		-- Server does not support functionality required to service request.

	service_unavailable: like ok
		-- Server is currently unable to handle request due to
		-- temporary overloading or maintenance of server.

	variant_also_negotiates: like ok
		-- Variant Also Negotiates

feature {NONE} -- Implementation

	new_table_text: STRING
		do
			Result := "[
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
end