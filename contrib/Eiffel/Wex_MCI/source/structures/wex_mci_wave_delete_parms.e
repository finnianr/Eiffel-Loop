indexing
	description: "This class represents the MCI_WAVE_DELETE_PARMS structure."
	status: "See notice at end of class."
	author: "Finnian Reilly"
	date: "$Date: 2006/06/26 16:30:29 $"
	revision: "$Revision: 1.1 $"

class
	WEX_MCI_WAVE_DELETE_PARMS

inherit
	WEX_MCI_GENERIC_PARMS
		rename
			make as generic_make
		redefine
			structure_size
		end

creation
	make,
	make_by_pointer

feature {NONE} -- Initialization

	make (a_parent: WEL_COMPOSITE_WINDOW; a_wave_delete_from, a_wave_delete_to: INTEGER) is
			-- Make object and fill structure.
		require
			a_parent_not_void: a_parent /= Void
			a_parent_exists: a_parent.exists
			positive_wave_delete_from: a_wave_delete_from >= 0
			positive_wave_delete_to: a_wave_delete_from >= 0
		do
			if not exists then
				structure_make
			end
			generic_make (a_parent)
			set_wave_delete_from (a_wave_delete_from)
			set_wave_delete_to (a_wave_delete_to)
		ensure
			exists: exists
		end

feature -- Status report

	wave_delete_from: INTEGER is
			-- Postion to wave_delete from.
		require
			exists: exists
		do
			Result := cwex_mci_wave_delete_get_from (item)
		ensure
			positive_result: Result >= 0
		end

	wave_delete_to: INTEGER is
			-- Position to wave_delete to.
		require
			exists: exists
		do
			Result := cwex_mci_wave_delete_get_to (item)
		ensure
			positive_result: Result >= 0
		end

feature -- Status setting

	set_wave_delete_from (a_wave_delete_from: INTEGER) is
			-- Set postion to wave_delete from.
		require
			exists: exists
			positive_position: a_wave_delete_from >= 0
		do
			cwex_mci_wave_delete_set_from (item, a_wave_delete_from)
		ensure
			wave_delete_from_set: wave_delete_from = a_wave_delete_from
		end

	set_wave_delete_to (a_wave_delete_to: INTEGER) is
			-- Set position to wave_delete to.
		require
			exists: exists
			positive_position: a_wave_delete_to >= 0
		do
			cwex_mci_wave_delete_set_to (item, a_wave_delete_to)
		ensure
			wave_delete_to_set: wave_delete_to = a_wave_delete_to
		end
		
feature {WEL_STRUCTURE}

	structure_size: INTEGER is
			-- Size to allocate (in bytes)
		once
			Result := c_size_of_mci_wave_delete_parms
		end

feature {NONE} -- Externals

	c_size_of_mci_wave_delete_parms: INTEGER is
		external
			"C [macro <wave_delete.h>]"
		alias
			"sizeof (MCI_WAVE_DELETE_PARMS)"
		end

	cwex_mci_wave_delete_set_from (p: POINTER; value: INTEGER) is
		external
			"C [macro <wave_delete.h>]"
		end

	cwex_mci_wave_delete_set_to (p: POINTER; value: INTEGER) is
		external
			"C [macro <wave_delete.h>]"
		end


	cwex_mci_wave_delete_get_from (p: POINTER): INTEGER is
		external
			"C [macro <wave_delete.h>]"
		end

	cwex_mci_wave_delete_get_to (p: POINTER): INTEGER is
		external
			"C [macro <wave_delete.h>]"
		end

end -- class WEX_MCI_WAVE_DELETE_PARMS

--|-------------------------------------------------------------------------
--| WEX, Windows Eiffel library eXtension
--| Copyright (C) 1998  Robin van Ommeren, Andreas Leitner
--| See the file forum.txt included in this package for licensing info.
--|
--| Comments, Questions, Additions to this library? please contact:
--|
--| Robin van Ommeren			Andreas Leitner
--| Eikenlaan 54M			Arndtgasse 1/3/5
--| 7151 WT Eibergen			8010 Graz
--| The Netherlands			Austria
--| email: robin.van.ommeren@wxs.nl	email: andreas.leitner@teleweb.at
--| web: http://home.wxs.nl/~rommeren	web: about:blank
--|-------------------------------------------------------------------------