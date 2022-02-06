note
	description: "Loss calculator"

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
