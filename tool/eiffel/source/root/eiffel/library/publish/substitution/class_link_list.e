note
	description: "List of HTML links to Eiffel class documentation pages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-06 9:13:16 GMT (Thursday 6th June 2024)"
	revision: "10"

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

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create link_intervals.make_sized (count)
			create internal_list.make (5)
		end

feature -- Access

	expanded_list (link: CLASS_LINK): like internal_list
		require
			has_parameters: link.has_parameters
		local
			link_type: NATURAL_8
		do
			Result := internal_list
			Result.wipe_out
			if attached link_intervals as list and attached link.expanded_parameters as parameters then
				list.fill (parameters)
				from list.start until list.after loop
					link_type := list.item_link_type (parameters)
					if link_type > 0 then
						Result.extend (list.item_class_link (parameters, link_type))
					end
					list.forth
				end
			end
		end

	link_intervals: CLASS_LINK_OCCURRENCE_INTERVALS

feature -- Status query

	has_invalid_class: BOOLEAN
		-- `True' if at least one item entry has class_category = Unknown_class
		do
			Result := across Current as link some not link.item.is_valid end
		end

feature -- Measurement

	adjusted_count (line: ZSTRING): INTEGER
		-- `line.count' adjusted to exclude "${}" characters for valid class substitutions
		local
			class_link: CLASS_LINK
		do
			fill (line)
			Result := line.count
			from start until after loop
				class_link := item
				if class_link.has_parameters then
					Result := Result - expanded_list (class_link).count * Class_marker_count
				else
					Result := Result - Class_marker_count -- subtract "${}" characters
				end
				forth
			end
		end

	character_count (template_count: INTEGER; relative_page_dir: DIR_PATH): INTEGER
		-- approx. count of expanded characters
		local
			class_link: CLASS_LINK; relative_path: FILE_PATH
		do
			from start until after loop
				class_link := item
				if class_link.has_parameters then
					across expanded_list (class_link) as list loop
						relative_path := list.item.relative_path (relative_page_dir)
						Result := Result + template_count + relative_path.count
					end
				else
					relative_path := class_link.relative_path (relative_page_dir)
					Result := Result + template_count + relative_path.count
				end
				forth
			end
		end

feature -- Element change

	fill (code_text: ZSTRING)
		local
			link_type: NATURAL_8
		do
			wipe_out
			link_intervals.fill (code_text)
			if attached link_intervals as list then
				from list.start until list.after loop
					link_type := list.item_link_type (code_text)
					if link_type > 0 then
						extend (list.item_class_link (code_text, link_type))
					end
					list.forth
				end
			end
		end

feature -- Basic operations

	add_to_checksum (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; code_text: ZSTRING)
		local
			class_link: CLASS_LINK
		do
			fill (code_text)
			from start until after loop
				class_link := item
				if class_link.has_parameters then
					across expanded_list (class_link) as list loop
						crc.add_path (list.item.path)
					end
				else
					crc.add_path (class_link.path)
				end
				forth
			end
		end

	remove_class (eiffel_class: EIFFEL_CLASS)
		local
			key_list: EL_ZSTRING_LIST
		do
			create key_list.make (10)
			if attached link_intervals.class_link_table as class_link_table then
				across class_link_table as table loop
					if table.item.eiffel_class = eiffel_class then
						key_list.extend (table.key)
					end
				end
				key_list.do_all (agent class_link_table.remove)
			end
		end

	replace_class (old_class, new_class: EIFFEL_CLASS)
		do
			across link_intervals.class_link_table as table loop
				if table.item.eiffel_class = old_class then
					table.item.set_eiffel_class (new_class)
				end
			end
		end

feature {NONE} -- Internal attributes

	internal_list: EL_ARRAYED_LIST [CLASS_LINK]

feature {NONE} -- Constants

	Class_marker_count: INTEGER = 3
		-- same as: `("${}").count'

end