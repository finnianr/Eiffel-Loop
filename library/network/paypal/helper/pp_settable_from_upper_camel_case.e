note
	description: "Object that is reflectively settable from Paypal upper-camelCase variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 8:26:12 GMT (Tuesday 28th April 2020)"
	revision: "7"

class
	PP_SETTABLE_FROM_UPPER_CAMEL_CASE

inherit
	PP_REFLECTIVELY_SETTABLE
		rename
			export_name as to_paypal_name,
			import_name as from_camel_case_upper
		undefine
			import_from_camel_case_upper
		end

	EL_SETTABLE_FROM_ZSTRING

	PP_NAMING_ROUTINES

end
