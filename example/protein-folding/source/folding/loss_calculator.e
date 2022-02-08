note
	description: "Loss calculator"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:49:32 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	LOSS_CALCULATOR

create
	make

feature {NONE} -- Initialization

	make (a_grid: like grid; delta_x, delta_y: INTEGER; a_point_set: like point_set)
		do
			grid := a_grid; point_set := a_point_set
			if delta_x = 0 then
				delta := delta_x
				is_x_delta := True
			else
				delta := delta_y
			end
		end

feature -- Access

	delta: INTEGER

	is_x_delta: BOOLEAN

	losses: INTEGER

feature -- Status query

	is_default: BOOLEAN
		do
		end

feature -- Basic operations

	find_losses
		do
			losses := grid.losses (point_set)
		end

feature {NONE} -- Internal attributes

	grid: BOOLEAN_GRID

	point_set: NATURAL

end