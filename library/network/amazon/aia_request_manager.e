note
	description: "Summary description for {AIA_ACCOUNT_LINKING_CONTROLLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-05 16:45:40 GMT (Tuesday 5th December 2017)"
	revision: "2"

class
	AIA_REQUEST_MANAGER

inherit
	EL_FACTORY_CLIENT

	EL_STRING_CONSTANTS

	AIA_SHARED_CREDENTIAL_LIST

	AIA_SHARED_CODES

create
	make

feature {NONE} -- Initialization

	make
		do
			create error_message.make_empty
			create get_user_id.make
			create purchase.make
			create revoke_purchase.make

			create request_table.make_equal (7)
			across request_types as type loop
				request_table [type.item.operation] := type.item
			end
		end

feature -- Access

	get_user_id: AIA_GET_USER_ID_REQUEST

	purchase: AIA_PURCHASE_REQUEST

	revoke_purchase: AIA_REVOKE_REQUEST

feature -- Basic operations

	error_message: STRING

	response (fcgi_request: FCGI_REQUEST_PARAMETERS): AIA_RESPONSE
		local
			operation: AIA_OPERATION; request: AIA_REQUEST
			verifier: AIA_VERIFIER
		do
			create verifier.make (fcgi_request, Credential_list)
			if verifier.is_verified then
				create operation.make (fcgi_request.content)
				request_table.search (operation.name)
				if request_table.found then
					request := request_table.found_item
					request.wipe_out
					request.set_from_json (operation.json_list)
					Result := request.response
				else
					Result := Fail_reponse
				end
			else
				error_message := "Request verification failed"
			end
		end

feature -- Status query

	has_error: BOOLEAN
		do
			Result := not error_message.is_empty
		end

feature {NONE} -- Internal attributes

	request_types: ARRAY [AIA_REQUEST]
		do
			Result := << get_user_id, purchase, revoke_purchase >>
		end

	request_table: EL_STRING_HASH_TABLE [AIA_REQUEST, STRING]

feature {NONE} -- Constants

	Fail_reponse: AIA_RESPONSE
		once
			create Result.make (Response_code.fail_other)
		end
end
