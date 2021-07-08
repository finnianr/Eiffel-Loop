note
	description: "Parameters for a NVP API button method call"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 11:10:16 GMT (Sunday 24th May 2020)"
	revision: "9"

class
	PP_BUTTON_METHOD [R -> PP_HTTP_RESPONSE create make_default, make end]

inherit
	PP_CONVERTABLE_TO_PARAMETER_LIST

	EL_MODULE_NAMING

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_connection: like connection)
		do
			make_default
			connection := a_connection
			method := "BM" + Naming.class_as_camel (Current, 1, 1)
			parameter_list := to_parameter_list
			parameter_list.append_tuple ([a_connection.credentials.http_parameters, a_connection.version])
		end

feature -- Basic operations

	call, query_result (arguments: TUPLE): R
		-- call API method
		local
			value_table: EL_URI_QUERY_ZSTRING_HASH_TABLE; old_count: INTEGER
		do
			connection.reset
			if is_lio_enabled then
				lio.put_labeled_substitution ("call", "(method, %S)", [method])
				lio.put_new_line
			end
			old_count := parameter_list.count
			parameter_list.append_tuple (arguments)
			value_table := parameter_list.to_table
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
			parameter_list.remove_tail (parameter_list.count - old_count)
		ensure
			same_parameter_list_count: old parameter_list.count = parameter_list.count
		end

feature {NONE} -- Paypal attributes

	method: ZSTRING

feature {NONE} -- Internal attributes

	connection: PP_NVP_API_CONNECTION

	parameter_list: EL_HTTP_PARAMETER_LIST

end
