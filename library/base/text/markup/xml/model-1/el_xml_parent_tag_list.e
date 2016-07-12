note
	description: "XML tag that has child tags"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-02 8:24:10 GMT (Tuesday 2nd June 2015)"
	revision: "2"

class
	EL_XML_PARENT_TAG_LIST

inherit
	EL_XML_TAG_LIST
		rename
			append_tags as append_child_tags
		redefine
			append_child_tags, new_line_after_open_tag
		end

create
	make, make_from_other
	
feature -- Element change
	
	append_child_tags (child_tags: EL_XML_TAG_LIST)
			--
		do
			finish
			child_tags.do_all (agent put_left)
		end
		
	append_real_value_array (names: ARRAY [STRING]; values: ARRAY [REAL])	
			--
		require
			same_size_arrays: names.count = values.count
		local
			i: INTEGER
			string_values: ARRAY [STRING]
		do
			create string_values.make (1, values.count)
			from i := 1 until i > names.count loop
				string_values [i] := values.item (i).out
				i := i + 1
			end
			append_string_value_array (names, string_values)
		end		
		
	append_string_value_array (names: ARRAY [STRING]; values: ARRAY [STRING])	
			--
		require
			same_size_arrays: names.count = values.count
		local
			xml_value_tag: EL_XML_VALUE_TAG_PAIR
			i: INTEGER
		do
			from i := 1 until i > names.count loop
				XML_value_tag_lookup.search (names [i])
				if XML_value_tag_lookup.found then
					xml_value_tag := XML_value_tag_lookup.found_item
				else
					create xml_value_tag.make (names [i])
					XML_value_tag_lookup.put (xml_value_tag, names [i])
				end
				xml_value_tag.set_string_value (values.item (i))
				append_child_tags (xml_value_tag)
				i := i + 1
			end
		end		

feature -- Status query

	has_children: BOOLEAN
			-- 
		do
			Result := count > 2
		end
		
feature -- Removal

	remove_children
			--
		do
			from
				start
			until
				count = 2
			loop
				remove_right
			end
		ensure
			only_2_tags_left: count = 2
		end

feature {NONE} -- Implementation

	new_line_after_open_tag: BOOLEAN = true
		
	XML_value_tag_lookup: HASH_TABLE [EL_XML_VALUE_TAG_PAIR, STRING]
			--
		once
			create Result.make (17)
		end
		
end

