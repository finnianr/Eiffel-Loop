note
	description: "Html meta values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-04 11:58:21 GMT (Saturday 4th April 2020)"
	revision: "1"

class
	EL_HTML_META_VALUES

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as to_kebab_case_lower,
			import_name as from_kebab_case,
			make_default as make
		export
			{NONE} all
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_default as make
		export
			{NONE} all
			{EL_HTML_META_VALUE_READER} set_field, field_table
		end

end
