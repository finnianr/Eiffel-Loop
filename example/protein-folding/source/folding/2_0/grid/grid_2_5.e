note
	description: "Two-dimensional ${BOOLEAN_GRID} using nested inspect for double direction loss calc"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:51:43 GMT (Tuesday 8th February 2022)"
	revision: "3"

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