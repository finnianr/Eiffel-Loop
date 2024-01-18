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
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

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