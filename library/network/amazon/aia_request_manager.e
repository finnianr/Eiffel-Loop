note
	description: "Summary description for {AIA_ACCOUNT_LINKING_CONTROLLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-27 15:48:44 GMT (Monday 27th November 2017)"
	revision: "1"

class
	AIA_REQUEST_MANAGER

inherit
	EL_FACTORY_CLIENT

	EL_STRING_CONSTANTS

feature -- Basic operations

	json_response (fcgi_request: FCGI_REQUEST_PARAMETERS): STRING
		local
			operation: AIA_OPERATION; request: AIA_REQUEST
		do
			create operation.make (fcgi_request.content)
			if factory.has_type (operation.name) then
				request := factory.instance_from_alias (operation.name, agent {AIA_REQUEST}.make (operation.json_list))
				Result := request.json_response
			else
				Result := Empty_string_8
			end
		end

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [AIA_REQUEST]
		once
			create Result.make_from_table (<<
				["get_user_id", {AIA_GET_USER_ID_REQUEST}]
			>>)
		end
end
