note
	description: "Parameters for a NVP API button method call"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:26:41 GMT (Wednesday 6th December 2023)"
	revision: "12"

class
	PP_BUTTON_METHOD [R -> PP_HTTP_RESPONSE create make_default, make end]

inherit
	PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER

	EL_MODULE_LIO; EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make (a_connection: like connection)
		do
			connection := a_connection
			method := BM_prefix + Naming.class_as_camel (Current, 1, 1)
			create parameter_list.make (<<
				a_connection.credentials.http_parameter, a_connection.version.to_parameter, to_parameter
			>>)
		end

feature -- Basic operations

	call, query_result (arguments: ARRAY [EL_CONVERTIBLE_TO_HTTP_PARAMETER]): R
		-- call API method
		local
			value_table: EL_URI_QUERY_ZSTRING_HASH_TABLE; i: INTEGER
		do
			connection.reset
			if is_lio_enabled then
				lio.put_labeled_substitution ("call", "(method, %S)", [method])
				lio.put_new_line
			end
			if attached Parameter_buffer as buffer then
				buffer.wipe_out
				buffer.append_sequence (parameter_list)
				from i := 1 until i > arguments.count loop
					arguments [i].to_parameter.add_to_list (buffer)
					i := i + 1
				end
				value_table := buffer.to_table
			end
			if is_lio_enabled then
				across value_table as l_value loop
					lio.put_labeled_string (l_value.key, l_value.item)
					lio.put_new_line
				end
			end
			connection.set_post_parameters (value_table)
			connection.read_string_post
			if connection.has_error then
				create Result.make_default
			else
				create Result.make (connection.last_string)
				Result.set_http_read_ok (True)
			end
		end

feature {NONE} -- Internal attributes

	connection: PP_NVP_API_CONNECTION

	method: ZSTRING
		--> METHOD=BMcreateButton

	parameter_list: EL_HTTP_PARAMETER_LIST

feature {NONE} -- Constants

	BM_prefix: ZSTRING
		once
			Result := "BM"
		end

	Parameter_buffer: EL_HTTP_PARAMETER_LIST
		once
			create Result.make_size (20)
		end

end