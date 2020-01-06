note
	description: "Object that is reflectively settable from Paypal upper-camelCase variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:11:01 GMT (Monday 1st July 2019)"
	revision: "6"

class
	PP_SETTABLE_FROM_UPPER_CAMEL_CASE

inherit
	PP_REFLECTIVELY_SETTABLE
		rename
			export_name as to_paypal_name,
			import_name as from_upper_camel_case
		undefine
			import_from_upper_camel_case
		end

	EL_SETTABLE_FROM_ZSTRING

	PP_NAMING_ROUTINES

end
