note
	description: "Two-dimensional [$source BOOLEAN_GRID] using nested inspect for double direction loss calc"
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
	GRID_2_5

inherit
	GRID_2_2
		redefine
			losses
		end

create
	make

feature -- Measurement

	losses (a_fold: SPECIAL [NATURAL_8]): INTEGER
		do
			Result := a.fold_losses (a_fold, used)
		end

end
