note
	description: "Summary description for {PP_REFLECTIVELY_SETTABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 12:47:56 GMT (Monday 23rd April 2018)"
	revision: "4"

class
	PP_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as to_paypal_name,
			import_name as from_upper_camel_case
		undefine
			import_from_upper_camel_case
		end

	EL_SETTABLE_FROM_ZSTRING

	PP_NAMING_ROUTINES
		undefine
			is_equal
		end

end
