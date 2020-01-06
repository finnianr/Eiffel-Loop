note
	description: "[
		Object that selects the appropriate request object for each Amazon Instant Access request
		and then returns a vendor response.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-05 11:41:26 GMT (Sunday 5th January 2020)"
	revision: "8"

class
	AIA_REQUEST_MANAGER

inherit
	EL_FACTORY_CLIENT

	EL_ZSTRING_CONSTANTS

	AIA_SHARED_CREDENTIAL_LIST

	AIA_SHARED_ENUMERATIONS

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
			operation: AIA_OPERATION; request: AIA_REQUEST; verifier: AIA_VERIFIER
		do
			create verifier.make (fcgi_request, Credential_list)
			if verifier.is_verified then
				create operation.make (fcgi_request.content)
				if request_table.has_key (operation.name) then
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
			create Result.make (response_enum.fail_other)
		end
end
