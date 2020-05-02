note
	description: "Enumeration of Paypal `L' variables"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 8:28:52 GMT (Tuesday 28th April 2020)"
	revision: "8"

class
	PP_L_VARIABLE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_paypal_name,
			import_name as from_camel_case_upper
		undefine
			import_from_camel_case_upper
		end

	PP_NAMING_ROUTINES

create
	make

feature -- L variables

	l_button_type: NATURAL_8
		-- "L_BUTTONTYPE"

	l_button_var: NATURAL_8
		-- "L_BUTTONVAR"

	l_hosted_button_id: NATURAL_8
		-- "L_HOSTEDBUTTONID"

	l_item_name: NATURAL_8
		-- "L_ITEMNAME"

	l_modify_date: NATURAL_8
		-- "L_MODIFYDATE"

	l_option_0_price: NATURAL_8
		-- "L_OPTION0PRICE"

	l_option_0_select: NATURAL_8
		-- "L_OPTION0SELECT"

feature -- Constants

	L_options: ARRAY [NATURAL_8]
		once
			Result := << l_option_0_select, l_option_0_price >>
		end

end
