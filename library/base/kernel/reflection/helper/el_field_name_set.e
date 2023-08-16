note
	description: "Field name SET"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-21 18:03:05 GMT (Friday 21st July 2023)"
	revision: "2"

class
	EL_FIELD_NAME_SET

inherit
	EL_HASH_SET [IMMUTABLE_STRING_8]
		rename
			make as make_sized
		end

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (name_list: STRING)
		-- subset of field indices from `name_list'
		local
			list: EL_SPLIT_IMMUTABLE_STRING_8_LIST; non_zero_count: INTEGER
		do
			if name_list.count > 0 then
				create list.make_shared_adjusted (name_list, ',', {EL_SIDE}.Left)

				non_zero_count := list.non_zero_count

				if non_zero_count > 0 then
					make_sized (non_zero_count)

					from list.start until list.after loop
						if list.item_count > 0 then
							put (list.item)
						end
						list.forth
					end
				else
					make_sized (0)
				end
			else
				make_sized (0)
			end
		end
end