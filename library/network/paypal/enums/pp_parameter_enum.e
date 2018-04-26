note
	description: "Summary description for {PP_PAYPAL_VARIABLES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 12:47:33 GMT (Monday 23rd April 2018)"
	revision: "4"

class
	PP_PARAMETER_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_paypal_name,
			import_name as from_upper_camel_case
		undefine
			import_from_upper_camel_case
		end

	PP_NAMING_ROUTINES
		undefine
			is_equal
		end

create
	make

feature -- Access

	ack: NATURAL_8
		-- ""

	acknowledge: NATURAL_8
		do
			Result := ack
		end

	button_code: NATURAL_8

	button_country: NATURAL_8

	button_language: NATURAL_8

	button_status: NATURAL_8

	button_sub_type: NATURAL_8

	button_type: NATURAL_8

	build: NATURAL_8

	correlation_id: NATURAL_8

	end_date: NATURAL_8

	hosted_button_id: NATURAL_8

	method: NATURAL_8

	notify_url: NATURAL_8

	start_date: NATURAL_8

	time_stamp: NATURAL_8

	version: NATURAL_8

	website_code: NATURAL_8

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
