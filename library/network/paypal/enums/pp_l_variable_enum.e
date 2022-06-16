note
	description: "Enumeration of Paypal `L' variables"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 9:58:51 GMT (Thursday 16th June 2022)"
	revision: "9"

class
	PP_L_VARIABLE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			foreign_naming as Paypal_naming
		end

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

feature {NONE} -- Constants

	Paypal_naming: PP_NAME_TRANSLATER
		once
			create Result.make
		end
end