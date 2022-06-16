note
	description: "Html meta values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 7:40:22 GMT (Thursday 16th June 2022)"
	revision: "3"

class
	EL_HTML_META_VALUES

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			make_default as make
		export
			{NONE} all
		redefine
			foreign_naming
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_default as make
		export
			{NONE} all
			{EL_HTML_META_VALUE_READER} set_field, field_table
		end

feature {NONE} -- Constants

	Foreign_naming: EL_KEBAB_CASE_TRANSLATER
		once
			create Result.make_lower
		end
end