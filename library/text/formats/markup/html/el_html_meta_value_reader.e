note
	description: "[
		Reads meta data fields from HTML document and set all fields in `meta_value: M' that have
		a corresponding field name. Assumes `/html/meta/name/text()' uses hyphenated names.

			feature -- Access

				meta_value: M
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-04 14:31:56 GMT (Saturday 4th April 2020)"
	revision: "2"

class
	EL_HTML_META_VALUE_READER [M -> EL_HTML_META_VALUES create make end]

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (html_path: EL_FILE_PATH)
		do
			make_machine
			create meta_value.make
			if html_path.exists then
				do_once_with_file_lines (agent find_names, create {EL_PLAIN_TEXT_LINE_SOURCE}.make_latin (1, html_path))
			end
		end

feature -- Access

	meta_value: M

feature {NONE} -- Implementation

	find_names (line: ZSTRING)
		local
			i: INTEGER; name, value: ZSTRING
		do
			if line.has_substring (Tag.head_end) or else value_count = meta_value.field_table.count then
				state := final
			else
				i := line.substring_right_index (Tag.meta, 1)
				if i > 0 then
					i := line.substring_right_index (Tag.name, i)
					if i > 0 then
						name := line.substring_between (Tag.quote, Tag.quote, i)
						if meta_value.field_table.has_name (name, meta_value) then
							i := line.substring_right_index (Tag.content, i)
							if i > 0 then
								value := line.substring_between (Tag.quote, Tag.quote, i)
								if not (value.starts_with (Tag.begin_undefined) and then value.ends_with (Tag.end_undefined)) then
									meta_value.set_field (name, value)
									value_count := value_count + 1
								end
							end
						end
					end
				end
			end
		end

feature {NONE} -- Initialization

	value_count: INTEGER

feature {NONE} -- Constants

	Tag: TUPLE [meta, name, content, head_end, quote, begin_undefined, end_undefined: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "<meta, name=, content=, </head>, %", ($, undefined)")
		end

end
