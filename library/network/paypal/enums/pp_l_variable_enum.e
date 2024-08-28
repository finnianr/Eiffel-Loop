note
	description: "Enumeration of Paypal `L' variables"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-28 6:37:00 GMT (Wednesday 28th August 2024)"
	revision: "14"

class
	PP_L_VARIABLE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			description_table as No_descriptions,
			foreign_naming as Paypal_naming
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			option_variables := << l_option_0_select, l_option_0_price >>
			error_variables := << l_error_code, l_severity_code >>
		end

feature -- L variables

	l_button_type: NATURAL_8
		-- "L_BUTTONTYPE"

	l_button_var: NATURAL_8
		-- "L_BUTTONVAR"

	l_error_code: NATURAL_8
		-- "L_ERRORCODE0=11925"

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

	l_severity_code: NATURAL_8
		-- "L_SEVERITYCODE0=Error"

feature -- Related variables

	option_variables: ARRAY [NATURAL_8]

	error_variables: ARRAY [NATURAL_8]

feature {NONE} -- Constants

	Paypal_naming: PP_NAME_TRANSLATER
		once
			create Result.make
		end
end