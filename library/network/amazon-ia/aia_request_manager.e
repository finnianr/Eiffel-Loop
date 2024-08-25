note
	description: "[
		Object that selects the appropriate request object for each Amazon Instant Access request
		and then returns a vendor response.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:32:34 GMT (Sunday 25th August 2024)"
	revision: "13"

class
	AIA_REQUEST_MANAGER

inherit
	ANY

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

	error_message: STRING

feature -- Basic operations

	response (fcgi_request: FCGI_REQUEST_PARAMETERS): AIA_RESPONSE
		local
			operation: AIA_OPERATION; request: AIA_REQUEST; verifier: AIA_VERIFIER
			template: ZSTRING
		do
			create verifier.make (fcgi_request, Credential_list)
			if verifier.is_verified then
				create operation.make (fcgi_request.content)
				if request_table.has_key (operation.name) then
					request := request_table.found_item
					request.wipe_out
					request.set_from_json_list (operation.json_list)
					Result := request.response
				else
					template := "not request_table.has (%"%S%")"
					error_message := template #$ [operation.name]
					Result := Fail_reponse
				end
			else
				error_message := "Request verification failed"
				Result := Fail_reponse
			end
		end

	print_verification (lio: EL_LOGGABLE; fcgi_request: FCGI_REQUEST_PARAMETERS)
		local
			verifier: AIA_VERIFIER
		do
			create verifier.make (fcgi_request, Credential_list)
			verifier.print_authorization (lio)
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

	Fail_reponse: AIA_FAIL_RESPONSE
		once
			create Result.make (response_enum.fail_other)
		end
end