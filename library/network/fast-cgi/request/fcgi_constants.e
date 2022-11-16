note
	description: "Fast-CGI constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	FCGI_CONSTANTS

feature {NONE} -- Application roles

	Fcgi_responder: INTEGER = 1

	Fcgi_authorizer: INTEGER = 2

	Fcgi_filter: INTEGER = 3

feature {NONE} -- Application status

	Fcgi_request_complete: INTEGER = 0

	Fcgi_cant_mpx_conn: INTEGER = 1

	Fcgi_overload: INTEGER = 2

	Fcgi_unknown_role: INTEGER = 3

feature {NONE} -- Record lengths

	Fcgi_header_len: INTEGER = 8

	Fcgi_end_req_body_len: INTEGER = 8

	Fcgi_begin_req_body_len: INTEGER = 8

	Fcgi_unknown_body_type_body_len: INTEGER = 8

feature {NONE} -- Constants

	Fcgi_max_len: INTEGER = 65535

	Fcgi_version: INTEGER = 1

	Fcgi_end_service: INTEGER = 12

	Fcgi_default_request_id: NATURAL_16 = 1

	Fcgi_keep_conn:INTEGER = 1

	Fcgi_max_conns: STRING = "FCGI_MAX_CONNS"
	Fcgi_max_reqs: STRING = "FCGI_MAX_REQS"
	Fcgi_mpxs_conns: STRING = "FCGI_MPXS_CONNS"

	Fcgi_stream_record: INTEGER = 0
	Fcgi_skip: INTEGER = 1
	Fcgi_begin_record: INTEGER = 2
	Fcgi_mgmt_record: INTEGER = 3

	Fcgi_unsupported_version: INTEGER = -2
	Fcgi_protocol_error: INTEGER = -3
	Fcgi_params_error: INTEGER = -4
	Fcgi_call_seq_error: INTEGER = -5

end