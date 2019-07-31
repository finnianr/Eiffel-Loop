/*
 * WAVE_DELETE.H
 *
 * Author: "Finnian Reilly"
 * date: "$Date: 2006/06/26 16:20:30 $"
 * revision: "$Revision: 1.1 $"
 */

#ifndef __WAVE_DELETE__
#define __WAVE_DELETE__

#ifndef __WEL_MCI__
#	include <wex_mci.h>
#endif

#include <generic.h>

#define cwex_mci_wave_delete_set_from(_ptr_, _value_) (((MCI_WAVE_DELETE_PARMS *) _ptr_)->dwFrom = (DWORD) (_value_))
#define cwex_mci_wave_delete_set_to(_ptr_, _value_) (((MCI_WAVE_DELETE_PARMS *)_ptr_)->dwTo = (DWORD) (_value_))

#define cwex_mci_wave_delete_get_from(_ptr_) ((((MCI_WAVE_DELETE_PARMS *) _ptr_)->dwFrom))
#define cwex_mci_wave_delete_get_to(_ptr_) ((((MCI_WAVE_DELETE_PARMS *)_ptr_)->dwTo))

#endif /* __WAVE_DELETE__ */

/*
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
*/
