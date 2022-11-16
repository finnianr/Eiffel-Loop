note
	description: "HTML meta values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_HTML_META_VALUES

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
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

feature {NONE} -- Constants

	Foreign_naming: EL_KEBAB_CASE_TRANSLATER
		once
			create Result.make_case ({EL_CASE}.Lower)
		end
end