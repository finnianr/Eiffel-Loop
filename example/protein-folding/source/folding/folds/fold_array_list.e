note
	description: "List of folds with object comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:50:54 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	FOLD_ARRAY_LIST

inherit
	ARRAYED_LIST [FOLD_ARRAY]
		rename
			make as make_array
		export
			{NONE} compare_objects, compare_references
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_array (50)
			compare_objects
		end

end