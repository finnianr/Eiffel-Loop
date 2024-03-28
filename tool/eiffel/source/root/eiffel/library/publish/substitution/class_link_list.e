note
	description: "List of HTML links to Eiffel class documentation pages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-28 17:21:53 GMT (Thursday 28th March 2024)"
	revision: "5"

class
	CLASS_LINK_LIST

inherit
	EL_ARRAYED_LIST [CLASS_LINK]
		rename
			fill as fill_list
		export
			{NONE} all
			{ANY} back, start, forth, finish, before, after, item, off, do_all
		redefine
			initialize
		end

	PUBLISHER_CONSTANTS

	SHARED_CLASS_PATH_TABLE; SHARED_ISE_CLASS_TABLE

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create class_link_intervals.make_sized (count)
			create parameter_link_intervals.make_sized (5)
		end

feature -- Access

	class_link_intervals: CLASS_LINK_OCCURRENCE_INTERVALS

feature -- Status query

	has_invalid_class: BOOLEAN
		-- `True' if at least one item entry has class_category = Unknown_class

feature -- Measurement

	adjusted_count (line: ZSTRING): INTEGER
		-- `line.count' adjusted to exclude "${}" characters for valid class substitutions
		do
			Result := line.count
			class_link_intervals.fill (line)
			if attached class_link_intervals as list then
				from list.start until list.after loop
					list.update_item_type (line)
					if attached list.item_type.is_valid then
						Result := Result - Class_marker_count -- subtract "${}" characters
					end
					list.forth
				end
			end
		end

	character_count (template_count: INTEGER): INTEGER
		-- approx. count of expanded characters
		do
			Result := template_count + sum_integer (agent {CLASS_LINK}.path_count)
		end

feature -- Element change

	fill (code_text: ZSTRING)
		do
			class_link_intervals.fill (code_text)
			fill_with_intervals (code_text, class_link_intervals)
		end

	fill_with_intervals (code_text: ZSTRING; interval_list: like class_link_intervals)
		do
			wipe_out
			has_invalid_class := False
			if attached interval_list as list then
				from list.start until list.after loop
					list.update_item_type (code_text)
					if attached list.item_type as type and then type.is_valid then
						extend (new_link (code_text, type.name, list))
					else
						has_invalid_class := True
					end
					list.forth
				end
			end
		end

feature -- Basic operations

	add_to_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; code_text: ZSTRING)
		local
			parameter_code_text: ZSTRING
		do
			class_link_intervals.fill (code_text)
			if attached class_link_intervals as list then
				from list.start until list.after loop
					if list.item_has_parameter (code_text) then
						parameter_code_text := code_text.substring (list.item_lower, list.item_upper)
						parameter_link_intervals.fill (parameter_code_text)
						parameter_link_intervals.edit_class_parameters (parameter_code_text)
						parameter_link_intervals.fill (parameter_code_text)
						if attached parameter_link_intervals as interval then
							from interval.start until interval.after loop
								add_intervals_to_crc (crc, parameter_code_text, interval)
								interval.forth
							end
						end
					else
						add_intervals_to_crc (crc, code_text, list)
					end
					list.forth
				end
			end
		end

feature {NONE} -- Implementation

	add_intervals_to_crc (
		crc: EL_CYCLIC_REDUNDANCY_CHECK_32; code_text: ZSTRING; intervals: CLASS_LINK_OCCURRENCE_INTERVALS
	)
		do
			intervals.update_item_type (code_text)
			if attached intervals.item_type as type and then type.is_valid then
				crc.add_path (new_link (code_text, type.name, intervals).path)
			end
		end

	new_link (code_text, name: ZSTRING; intervals: CLASS_LINK_OCCURRENCE_INTERVALS): CLASS_LINK
		do
			if Class_path_table.has_class (name) then
				create {DEVELOPER_CLASS_LINK} Result.make (Class_path_table.found_item, code_text, intervals)

			elseif ISE_class_table.has_class (name) then
				create {ISE_CLASS_LINK} Result.make (ISE_class_table.found_item, code_text, intervals)
			else
				create Result.make (Invalid_class, code_text, intervals)
			end
		end

feature {NONE} -- Internal attributes

	parameter_link_intervals: CLASS_LINK_OCCURRENCE_INTERVALS

feature {NONE} -- Constants

	Class_marker_count: INTEGER = 3
		-- same as: `("${}").count'

	Invalid_class: FILE_PATH
		once
			Result := "invalid-class-name"
		end

end