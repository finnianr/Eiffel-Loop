note
	description: "List of folds with object comparison"

	author: "Finnian Reilly"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

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
