note
	description: "Paypal button meta data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-10 13:06:07 GMT (Sunday 10th October 2021)"
	revision: "4"

class
	PP_BUTTON_META_DATA

inherit
	PP_SETTABLE_FROM_UPPER_CAMEL_CASE

create
	make_default

feature -- Access

	l_button_type: STRING

	l_hosted_button_id: STRING

	l_item_name: ZSTRING

	l_modify_date: EL_ISO_8601_DATE_TIME

	hosted_button: PP_HOSTED_BUTTON
		do
			create Result.make (l_hosted_button_id)
		end

end