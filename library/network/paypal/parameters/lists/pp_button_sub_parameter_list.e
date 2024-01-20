note
	description: "[
		List of button variables for requests
		[https://developer.paypal.com/docs/classic/api/button-manager/BMCreateButton_API_Operation_NVP/
		BMCreateButton]
		and
		[https://developer.paypal.com/docs/classic/api/button-manager/BMUpdateButton_API_Operation_NVP/
		BMUpdateButton]
		
		Createable from instance of ${PP_PRODUCT_INFO} using `make_from_object'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	PP_BUTTON_SUB_PARAMETER_LIST

inherit
	PP_SUB_PARAMETER_LIST

create
	make, make_from_object

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "L_BUTTONVAR%S"
		end

end