note
	description: "Sub-application help list sortable by **option_name**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-17 7:42:59 GMT (Monday 17th March 2025)"
	revision: "15"

class
	EL_APPLICATION_HELP_LIST

inherit
	EL_ARRAYED_MAP_LIST [
		READABLE_STRING_GENERAL, TUPLE [description: READABLE_STRING_GENERAL; default_value: ANY]
	]
		rename
			extend as extend_pair
		end

	EL_MODULE_LIO

	EL_CHARACTER_32_CONSTANTS; EL_ZSTRING_CONSTANTS


create
	make

feature -- Basic operations

	print_to_lio
		local
			option: ZSTRING; line_list: LIST [READABLE_STRING_GENERAL]
		do
			lio.put_line ("COMMAND LINE OPTIONS:")
			lio.put_new_line

			sort_by_key (True)

			from start until after loop
				option := (hyphen * 1) + item_key
				line_list := item_value.description.split ('%N')
				lio.put_spaces (4)
				if line_list.count = 1 and then line_list.first.count <= 70 then
					lio.put_labeled_string (option, line_list.first)
					line_list.wipe_out
				else
					lio.put_labeled_string (option, Empty_string)
				end
				lio.put_new_line
				across line_list as line loop
					lio.put_spaces (5); lio.put_line (line.item)
				end
				if attached default_value_string (item_value.default_value) as str and then str.count > 0 then
					lio.put_spaces (5); lio.put_labeled_string ("Default", str)
					lio.put_new_line
				end
				lio.put_new_line
				forth
			end
		end

feature -- Element change

	extend (name, description: READABLE_STRING_GENERAL; default_value: ANY)
		do
			extend_pair (name, [description, default_value])
		end

feature {NONE} -- Implementation

	default_value_string (value: ANY): ZSTRING
		do
			if attached {READABLE_STRING_GENERAL} value as str then
				create Result.make_from_general (str)
			elseif attached {EL_PATH} value as path then
				Result := path.to_string
			elseif attached {CHAIN [ANY]} value as chain then
				create Result.make_empty
			elseif attached {BOOLEAN_REF} value as bool then
				if bool.item then
					Result := "enabled"
				else
					Result := "disabled"
				end
			else
				Result := value.out
			end
		end

end