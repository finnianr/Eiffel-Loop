note
	description: "Parameters for a NVP API button method call"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-13 13:28:01 GMT (Friday 13th April 2018)"
	revision: "4"

class
	PP_BUTTON_METHOD [R -> PP_HTTP_RESPONSE create make_default, make end]

inherit
	PP_NAME_VALUE_PARAMETER
		rename
			make as make_parameter
		end

	PP_SHARED_PARAMETER_ENUM

	EL_MODULE_NAMING

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		do
			make_parameter (Parameter.method, "BM" + Naming.crop_as_camel_case (generator, 3, 7))
		end

feature -- Basic operations

	call, query_result (connection: PP_NVP_API_CONNECTION; arguments: ARRAY [EL_HTTP_PARAMETER]): R
		-- call API method
		local
			parameter_list: EL_HTTP_PARAMETER_LIST [EL_HTTP_PARAMETER]
			value_table: EL_URL_QUERY_HASH_TABLE
		do
			connection.reset
			if is_lio_enabled then
				lio.put_labeled_substitution ("call", "(%S, %S)", [name, value])
				lio.put_new_line
			end
			create parameter_list.make (<< connection.credentials.http_parameters, connection.api_version, Current >> )
			parameter_list.append_array (arguments)

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
			end
			Result.set_http_read_ok (connection.last_call_succeeded)
		end

end
