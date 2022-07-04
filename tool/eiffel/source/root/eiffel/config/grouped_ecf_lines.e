note
	description: "ECF lines grouped under a custom tag: ''debugging: settings:'' etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-04 11:47:46 GMT (Monday 4th July 2022)"
	revision: "4"

class
	GROUPED_ECF_LINES

inherit
	EL_STRING_8_LIST
		rename
			make as make_list
		export
			{NONE} all
		end

create
	make_truncated, make, make_empty

feature {NONE} -- Initialization

	make_truncated (a_expanded_template: like expanded_template; a_tab_count: INTEGER; line: STRING)
		-- make with first line removed on first call to `set_from_line'
		do
			create first_line_removed
			make (a_expanded_template, a_tab_count, line)
		end

	make (a_expanded_template: like expanded_template; a_tab_count: INTEGER; line: STRING)
		do
			make_empty
			expanded_template := a_expanded_template; tab_count := a_tab_count
			set_from_line (line)
		end

feature -- Access

	tab_count: INTEGER

feature -- Element change

	set_from_line (a_line: STRING)
		do
			wipe_out
			if attached shared_name_value_list (a_line) as nvp_list then
				grow (nvp_list.count * 2)
				across nvp_list as list loop
					across expanded_template (list.item).split ('%N') as line loop
						extend (line.item)
					end
				end
				indent (tab_count)
			end
			if attached first_line_removed as removed and then not removed.item then
				start; remove
				removed.set_item (True)
			end
		end

feature -- Factory

	shared_name_value_list (line: STRING): detachable like Once_name_value_list
		local
			pair_splitter: like Once_pair_splitter
			nvp: EL_NAME_VALUE_PAIR [STRING]
		do
			pair_splitter := Once_pair_splitter
			pair_splitter.set_target (line)
			if attached Once_name_value_list as list then
				list.wipe_out
				across pair_splitter as split loop
					if split.item_has ('=') then
						create nvp.make (split.item, '=')
						nvp.name.adjust
						adjust_value (nvp.value)
						list.extend (nvp)
					end
				end
				if list.count > 0 then
					Result := list
				end
			end
		end

feature {NONE} -- Implementation

	adjust_value (value: STRING)
		do
		end

feature {NONE} -- Internal attributes

	first_line_removed: BOOLEAN_REF

	expanded_template: FUNCTION [EL_NAME_VALUE_PAIR [STRING], STRING]

feature {NONE} -- Constants

	Once_name_value_list: EL_ARRAYED_LIST [EL_NAME_VALUE_PAIR [STRING]]
		once
			create Result.make (7)
		end

	Once_pair_splitter: EL_SPLIT_ON_CHARACTER [STRING]
		once
			create Result.make_adjusted ("", ';', {EL_STRING_ADJUST}.Left)
		end

end