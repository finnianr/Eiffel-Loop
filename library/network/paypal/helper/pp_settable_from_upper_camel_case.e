note
	description: "Object that is reflectively settable from Paypal upper-camelCase variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	PP_SETTABLE_FROM_UPPER_CAMEL_CASE

inherit
	PP_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as Paypal_naming
		end

	EL_SETTABLE_FROM_ZSTRING

feature {NONE} -- Constants

	Paypal_naming: PP_NAME_TRANSLATER
		once
			create Result.make
		end

end