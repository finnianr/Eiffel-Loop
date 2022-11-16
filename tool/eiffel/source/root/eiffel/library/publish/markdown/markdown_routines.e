note
	description: "Markdown routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	MARKDOWN_ROUTINES

feature {NONE} -- Implementation

	is_list_item (line: ZSTRING): BOOLEAN
		local
			pos_dot: INTEGER
		do
			if line.starts_with (Bullet_point) then
				Result := True
			else
				pos_dot := line.index_of ('.', 1)
				if pos_dot > 0 and then line.count > pos_dot
					and then line.substring (1, pos_dot - 1).is_natural and then line [pos_dot + 1] = ' '
				then
					Result := True
				end
			end
		end

	list_type (line: ZSTRING): STRING
		require
			is_list_item: is_list_item (line)
		do
			if line.starts_with (Bullet_point) then
				Result := Type_unordered_list
			else
				Result := Type_ordered_list
			end
		end

	list_prefix_count (line: ZSTRING): INTEGER
		require
			is_list_item: is_list_item (line)
		do
			if line.starts_with (Bullet_point) then
				Result := 2
			else
				Result := line.index_of ('.', 1) + 1
			end
		end

feature {NONE} -- Constants

	Bullet_point: ZSTRING
		once
			Result := "* "
		end

	Type_ordered_list: STRING = "ol"

	Type_unordered_list: STRING = "ul"

end