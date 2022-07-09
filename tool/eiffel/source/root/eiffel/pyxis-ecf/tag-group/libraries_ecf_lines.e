note
	description: "[
		[$source GROUPED_ECF_LINES] for **library** tags with an option with an optional common ''location''
	]"
	notes: "[
		**location** is interpreted as a location prefix only if it's on the first line
		
			libraries:
				location = "$ISE_LIBRARY/library"
				base = "base/base.ecf"
				thread = "thread/thread.ecf"
				time = "time/time.ecf"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-09 9:34:45 GMT (Saturday 9th July 2022)"
	revision: "6"

class
	LIBRARIES_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			set_from_line, adjust_value, exit, is_related_line, Template
		end

create
	make

feature -- Access

	tag_name: STRING
		do
			Result := Name.library
		end

feature -- Status query

	is_related_line (parser: PYXIS_ECF_PARSER; line: STRING; equal_index, indent_count, end_index: INTEGER): BOOLEAN
		do
			if attached parser.element (line, indent_count + 1, end_index) as tag
				and then Related_tags.has (tag)
			then
				Result := True

			elseif equal_index > 0 and then indent_count > tab_count + 1 then
				Result := True

			end
		end

feature -- Element change

	set_from_line (line: STRING)
		local
			s: EL_STRING_8_ROUTINES
		do
			if not first_line_removed
				and then not attached location_dir and then line.has_substring (Location)
				and then attached shared_name_value_list (line) as nvp_list
				and then nvp_list.count = 1 and then nvp_list.first.name ~ Location
				and then attached nvp_list.first.value as dir
			then
				s.remove_double_quote (dir)
				if dir [dir.count] /= '/' then
					dir.append_character ('/')
				end
				location_dir := dir
			else
				Precursor (line)
			end
		end

feature {NONE} -- Implementation

	adjust_value (value: STRING)
		do
			if attached location_dir as dir then
				value.insert_string (dir, 2)
			end
		end

	exit
		do
			location_dir := Void
		end

feature {NONE} -- Internal attributes

	location_dir: detachable STRING

feature {NONE} -- Constants

	Location: STRING = "location"

	Related_tags: EL_HASH_SET [STRING]
		once
			create Result.make_from_array (<< Name.assertions, Name.condition, Name.custom, Name.option, Name.renaming >>)
		end

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					name = $NAME; location = $VALUE
			]"
		end

end