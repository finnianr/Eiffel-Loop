note
	description: "Summary description for {PP_BUTTON_META_DATA}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 12:40:57 GMT (Saturday 16th December 2017)"
	revision: "1"

class
	PP_BUTTON_META_DATA

inherit
	PP_REFLECTIVELY_SETTABLE

create
	make_default

feature -- Access

	l_button_type: STRING

	l_hosted_button_id: STRING

	l_item_name: ZSTRING

	l_modify_date: EL_ISO_8601_DATE_TIME

end
