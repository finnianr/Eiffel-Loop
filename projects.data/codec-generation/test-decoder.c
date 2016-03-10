/* 
* Copyright (C) 2002-2009 XimpleWare, info@ximpleware.com
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/

#include "decoder.h"

void iso_8859_2_chars_init(){
	int i;
	if (iso_8859_2_chars_ready)
		return;
	else{
		for ( i = 0; i < 128; i++)
		{
			iso_8859_2_chars[i] = (char) i;
		}
		for ( i = 128; i < 256; i++)
		{
			iso_8859_2_chars[i] = (char) (0xfffd);
		}
		iso_8859_2_chars[0xA0] = (char) (0x00A0); /*	NO-BREAK SPACE */
		iso_8859_2_chars[0xA1] = (char) (0x0104); /*	LATIN CAPITAL LETTER A WITH OGONEK*/
		iso_8859_2_chars[0xA2] = (char) (0x02D8); /*	BREVE */
		iso_8859_2_chars[0xA3] = (char) (0x0141); /*	LATIN CAPITAL LETTER L WITH STROKE*/
		iso_8859_2_chars[0xA4] = (char) (0x00A4); /*	CURRENCY SIGN*/
		iso_8859_2_chars[0xA5] = (char) (0x013D); /*	LATIN CAPITAL LETTER L WITH CARON*/
		iso_8859_2_chars[0xA6] = (char) (0x015A); /*	LATIN CAPITAL LETTER S WITH ACUTE*/
		iso_8859_2_chars[0xA7] = (char) (0x00A7); /*	SECTION SIGN*/
		iso_8859_2_chars[0xA8] = (char) (0x00A8); /*	DIAERESIS*/
		iso_8859_2_chars[0xA9] = (char) (0x0160); /*	LATIN CAPITAL LETTER S WITH CARON*/
		iso_8859_2_chars[0xAA] = (char) (0x015E); /*	LATIN CAPITAL LETTER S WITH CEDILLA*/
		iso_8859_2_chars[0xAB] = (char) (0x0164); /*	LATIN CAPITAL LETTER T WITH CARON*/
		iso_8859_2_chars[0xAC] = (char) (0x0179); /*	LATIN CAPITAL LETTER Z WITH ACUTE*/
		iso_8859_2_chars[0xAD] = (char) (0x00AD); /*	SOFT HYPHEN*/
		iso_8859_2_chars[0xAE] = (char) (0x017D); /*	LATIN CAPITAL LETTER Z WITH CARON*/
		iso_8859_2_chars[0xAF] = (char) (0x017B); /*	LATIN CAPITAL LETTER Z WITH DOT ABOVE*/
		iso_8859_2_chars[0xB0] = (char) (0x00B0); /*	DEGREE SIGN*/
		iso_8859_2_chars[0xB1] = (char) (0x0105); /*	LATIN SMALL LETTER A WITH OGONEK*/
		iso_8859_2_chars[0xB2] = (char) (0x02DB); /*	OGONEK*/
		iso_8859_2_chars[0xB3] = (char) (0x0142); /*	LATIN SMALL LETTER L WITH STROKE*/
		iso_8859_2_chars[0xB4] = (char) (0x00B4); /*	ACUTE ACCENT*/
		iso_8859_2_chars[0xB5] = (char) (0x013E); /*	LATIN SMALL LETTER L WITH CARON*/
		iso_8859_2_chars[0xB6] = (char) (0x015B); /*	LATIN SMALL LETTER S WITH ACUTE*/
		iso_8859_2_chars[0xB7] = (char) (0x02C7); /*	CARON*/
		iso_8859_2_chars[0xB8] = (char) (0x00B8); /*	CEDILLA*/
		iso_8859_2_chars[0xB9] = (char) (0x0161); /*	LATIN SMALL LETTER S WITH CARON*/
		iso_8859_2_chars[0xBA] = (char) (0x015F); /*	LATIN SMALL LETTER S WITH CEDILLA*/
		iso_8859_2_chars[0xBB] = (char) (0x0165); /*	LATIN SMALL LETTER T WITH CARON*/
		iso_8859_2_chars[0xBC] = (char) (0x017A); /*	LATIN SMALL LETTER Z WITH ACUTE*/
		iso_8859_2_chars[0xBD] = (char) (0x02DD); /*	DOUBLE ACUTE ACCENT*/
		iso_8859_2_chars[0xBE] = (char) (0x017E); /*	LATIN SMALL LETTER Z WITH CARON*/
		iso_8859_2_chars[0xBF] = (char) (0x017C); /*	LATIN SMALL LETTER Z WITH DOT ABOVE*/
		iso_8859_2_chars[0xC0] = (char) (0x0154); /*	LATIN CAPITAL LETTER R WITH ACUTE*/
		iso_8859_2_chars[0xC1] = (char) (0x00C1); /*	LATIN CAPITAL LETTER A WITH ACUTE*/
		iso_8859_2_chars[0xC2] = (char) (0x00C2); /*	LATIN CAPITAL LETTER A WITH CIRCUMFLEX*/
		iso_8859_2_chars[0xC3] = (char) (0x0102); /*	LATIN CAPITAL LETTER A WITH BREVE*/
		iso_8859_2_chars[0xC4] = (char) (0x00C4); /*	LATIN CAPITAL LETTER A WITH DIAERESIS*/
		iso_8859_2_chars[0xC5] = (char) (0x0139); /*	LATIN CAPITAL LETTER L WITH ACUTE*/
		iso_8859_2_chars[0xC6] = (char) (0x0106); /*	LATIN CAPITAL LETTER C WITH ACUTE*/
		iso_8859_2_chars[0xC7] = (char) (0x00C7); /*	LATIN CAPITAL LETTER C WITH CEDILLA*/
		iso_8859_2_chars[0xC8] = (char) (0x010C); /*	LATIN CAPITAL LETTER C WITH CARON*/
		iso_8859_2_chars[0xC9] = (char) (0x00C9); /*	LATIN CAPITAL LETTER E WITH ACUTE*/
		iso_8859_2_chars[0xCA] = (char) (0x0118); /*LATIN CAPITAL LETTER E WITH OGONEK*/
		iso_8859_2_chars[0xCB] = (char) (0x00CB); /*	LATIN CAPITAL LETTER E WITH DIAERESIS*/
		iso_8859_2_chars[0xCC] = (char) (0x011A); /*	LATIN CAPITAL LETTER E WITH CARON*/
		iso_8859_2_chars[0xCD] = (char) (0x00CD); /*	LATIN CAPITAL LETTER I WITH ACUTE*/
		iso_8859_2_chars[0xCE] = (char) (0x00CE); /*	LATIN CAPITAL LETTER I WITH CIRCUMFLEX*/
		iso_8859_2_chars[0xCF] = (char) (0x010E); /*	LATIN CAPITAL LETTER D WITH CARON*/
		iso_8859_2_chars[0xD0] = (char) (0x0110); /*	LATIN CAPITAL LETTER D WITH STROKE*/
		iso_8859_2_chars[0xD1] = (char) (0x0143); /*	LATIN CAPITAL LETTER N WITH ACUTE*/
		iso_8859_2_chars[0xD2] = (char) (0x0147); /*	LATIN CAPITAL LETTER N WITH CARON*/
		iso_8859_2_chars[0xD3] = (char) (0x00D3); /*	LATIN CAPITAL LETTER O WITH ACUTE*/
		iso_8859_2_chars[0xD4] = (char) (0x00D4); /*	LATIN CAPITAL LETTER O WITH CIRCUMFLEX*/
		iso_8859_2_chars[0xD5] = (char) (0x0150); /*	LATIN CAPITAL LETTER O WITH DOUBLE ACUTE*/
		iso_8859_2_chars[0xD6] = (char) (0x00D6); /*	LATIN CAPITAL LETTER O WITH DIAERESIS*/
		iso_8859_2_chars[0xD7] = (char) (0x00D7); /*	MULTIPLICATION SIGN*/
		iso_8859_2_chars[0xD8] = (char) (0x0158); /*	LATIN CAPITAL LETTER R WITH CARON*/
		iso_8859_2_chars[0xD9] = (char) (0x016E); /*	LATIN CAPITAL LETTER U WITH RING ABOVE*/
		iso_8859_2_chars[0xDA] = (char) (0x00DA); /*	LATIN CAPITAL LETTER U WITH ACUTE*/
		iso_8859_2_chars[0xDB] = (char) (0x0170); /*	LATIN CAPITAL LETTER U WITH DOUBLE ACUTE*/
		iso_8859_2_chars[0xDC] = (char) (0x00DC); /*	LATIN CAPITAL LETTER U WITH DIAERESIS*/
		iso_8859_2_chars[0xDD] = (char) (0x00DD); /*	LATIN CAPITAL LETTER Y WITH ACUTE*/
		iso_8859_2_chars[0xDE] = (char) (0x0162); /*	LATIN CAPITAL LETTER T WITH CEDILLA*/
		iso_8859_2_chars[0xDF] = (char) (0x00DF); /*	LATIN SMALL LETTER SHARP S*/
		iso_8859_2_chars[0xE0] = (char) (0x0155); /*	LATIN SMALL LETTER R WITH ACUTE*/
		iso_8859_2_chars[0xE1] = (char) (0x00E1); /*	LATIN SMALL LETTER A WITH ACUTE*/
		iso_8859_2_chars[0xE2] = (char) (0x00E2); /*	LATIN SMALL LETTER A WITH CIRCUMFLEX*/
		iso_8859_2_chars[0xE3] = (char) (0x0103); /*	LATIN SMALL LETTER A WITH BREVE*/
		iso_8859_2_chars[0xE4] = (char) (0x00E4); /*	LATIN SMALL LETTER A WITH DIAERESIS*/
		iso_8859_2_chars[0xE5] = (char) (0x013A); /*	LATIN SMALL LETTER L WITH ACUTE*/
		iso_8859_2_chars[0xE6] = (char) (0x0107); /*	LATIN SMALL LETTER C WITH ACUTE*/
		iso_8859_2_chars[0xE7] = (char) (0x00E7); /*	LATIN SMALL LETTER C WITH CEDILLA*/
		iso_8859_2_chars[0xE8] = (char) (0x010D); /*	LATIN SMALL LETTER C WITH CARON*/
		iso_8859_2_chars[0xE9] = (char) (0x00E9); /*	LATIN SMALL LETTER E WITH ACUTE*/
		iso_8859_2_chars[0xEA] = (char) (0x0119); /*	LATIN SMALL LETTER E WITH OGONEK*/
		iso_8859_2_chars[0xEB] = (char) (0x00EB); /*	LATIN SMALL LETTER E WITH DIAERESIS*/
		iso_8859_2_chars[0xEC] = (char) (0x011B); /*	LATIN SMALL LETTER E WITH CARON*/
		iso_8859_2_chars[0xED] = (char) (0x00ED); /*	LATIN SMALL LETTER I WITH ACUTE*/
		iso_8859_2_chars[0xEE] = (char) (0x00EE); /*	LATIN SMALL LETTER I WITH CIRCUMFLEX*/
		iso_8859_2_chars[0xEF] = (char) (0x010F); /*	LATIN SMALL LETTER D WITH CARON*/
		iso_8859_2_chars[0xF0] = (char) (0x0111); /*	LATIN SMALL LETTER D WITH STROKE*/
		iso_8859_2_chars[0xF1] = (char) (0x0144); /*	LATIN SMALL LETTER N WITH ACUTE*/
		iso_8859_2_chars[0xF2] = (char) (0x0148); /*	LATIN SMALL LETTER N WITH CARON*/
		iso_8859_2_chars[0xF3] = (char) (0x00F3); /*	LATIN SMALL LETTER O WITH ACUTE*/
		iso_8859_2_chars[0xF4] = (char) (0x00F4); /*	LATIN SMALL LETTER O WITH CIRCUMFLEX*/
		iso_8859_2_chars[0xF5] = (char) (0x0151); /*	LATIN SMALL LETTER O WITH DOUBLE ACUTE*/
		iso_8859_2_chars[0xF6] = (char) (0x00F6); /*	LATIN SMALL LETTER O WITH DIAERESIS*/
		iso_8859_2_chars[0xF7] = (char) (0x00F7); /*	DIVISION SIGN*/
		iso_8859_2_chars[0xF8] = (char) (0x0159); /*	LATIN SMALL LETTER R WITH CARON*/
		iso_8859_2_chars[0xF9] = (char) (0x016F); /*LATIN SMALL LETTER U WITH RING ABOVE*/
		iso_8859_2_chars[0xFA] = (char) (0x00FA); /*	LATIN SMALL LETTER U WITH ACUTE*/
		iso_8859_2_chars[0xFB] = (char) (0x0171); /*	LATIN SMALL LETTER U WITH DOUBLE ACUTE*/
		iso_8859_2_chars[0xFC] = (char) (0x00FC); /*LATIN SMALL LETTER U WITH DIAERESIS*/
		iso_8859_2_chars[0xFD] = (char) (0x00FD); /*	LATIN SMALL LETTER Y WITH ACUTE*/
		iso_8859_2_chars[0xFE] = (char) (0x0163); /*LATIN SMALL LETTER T WITH CEDILLA*/
		iso_8859_2_chars[0xFF] = (char) (0x02D9); /*	DOT ABOVE*/

		iso_8859_2_chars_ready = TRUE;
	}
}

void iso_8859_15_chars_init(){
	int i;
	if (iso_8859_15_chars_ready)
		return;
	else{
		for (i = 0; i < 256; i++)
		{
			iso_8859_15_chars[i] = (char) i;
		}

		iso_8859_15_chars[0xA4] = (char) (0x20AC);
		iso_8859_15_chars[0xA6] = (char) (0x0160);
		iso_8859_15_chars[0xA8] = (char) (0x0161);
		iso_8859_15_chars[0xB4] = (char) (0x017D);
		iso_8859_15_chars[0xB8] = (char) (0x017E);
		iso_8859_15_chars[0xBC] = (char) (0x0152);
		iso_8859_15_chars[0xBD] = (char) (0x0153);
		iso_8859_15_chars[0xBE] = (char) (0x0178);
		iso_8859_15_chars_ready = TRUE;
	}
}

void iso_8859_9_chars_init(){
	int i;
	if (iso_8859_9_chars_ready)
		return;
	else{
		for (i = 0; i < 128; i++)
		{
			iso_8859_9_chars[i] = (char) i;
		}
		for (i = 128; i < 256; i++)
		{
			iso_8859_9_chars[i] = (char) (0xfffd);
		}

		iso_8859_9_chars[0xA0] = (char) (0x00A0);
		iso_8859_9_chars[0xA1] = (char) (0x00A1);
		iso_8859_9_chars[0xA2] = (char) (0x00A2);
		iso_8859_9_chars[0xA3] = (char) (0x00A3);
		iso_8859_9_chars[0xA4] = (char) (0x00A4);
		iso_8859_9_chars[0xA5] = (char) (0x00A5);
		iso_8859_9_chars[0xA6] = (char) (0x00A6);
		iso_8859_9_chars[0xA7] = (char) (0x00A7);
		iso_8859_9_chars[0xA8] = (char) (0x00A8);
		iso_8859_9_chars[0xA9] = (char) (0x00A9);
		iso_8859_9_chars[0xAA] = (char) (0x00AA);
		iso_8859_9_chars[0xAB] = (char) (0x00AB);
		iso_8859_9_chars[0xAC] = (char) (0x00AC);
		iso_8859_9_chars[0xAD] = (char) (0x00AD);
		iso_8859_9_chars[0xAE] = (char) (0x00AE);
		iso_8859_9_chars[0xAF] = (char) (0x00AF);
		iso_8859_9_chars[0xB0] = (char) (0x00B0);
		iso_8859_9_chars[0xB1] = (char) (0x00B1);
		iso_8859_9_chars[0xB2] = (char) (0x00B2);
		iso_8859_9_chars[0xB3] = (char) (0x00B3);
		iso_8859_9_chars[0xB4] = (char) (0x00B4);
		iso_8859_9_chars[0xB5] = (char) (0x00B5);
		iso_8859_9_chars[0xB6] = (char) (0x00B6);
		iso_8859_9_chars[0xB7] = (char) (0x00B7);
		iso_8859_9_chars[0xB8] = (char) (0x00B8);
		iso_8859_9_chars[0xB9] = (char) (0x00B9);
		iso_8859_9_chars[0xBA] = (char) (0x00BA);
		iso_8859_9_chars[0xBB] = (char) (0x00BB);
		iso_8859_9_chars[0xBC] = (char) (0x00BC);
		iso_8859_9_chars[0xBD] = (char) (0x00BD);
		iso_8859_9_chars[0xBE] = (char) (0x00BE);
		iso_8859_9_chars[0xBF] = (char) (0x00BF);
		iso_8859_9_chars[0xC0] = (char) (0x00C0);
		iso_8859_9_chars[0xC1] = (char) (0x00C1);
		iso_8859_9_chars[0xC2] = (char) (0x00C2);
		iso_8859_9_chars[0xC3] = (char) (0x00C3);
		iso_8859_9_chars[0xC4] = (char) (0x00C4);
		iso_8859_9_chars[0xC5] = (char) (0x00C5);
		iso_8859_9_chars[0xC6] = (char) (0x00C6);
		iso_8859_9_chars[0xC7] = (char) (0x00C7);
		iso_8859_9_chars[0xC8] = (char) (0x00C8);
		iso_8859_9_chars[0xC9] = (char) (0x00C9);
		iso_8859_9_chars[0xCA] = (char) (0x00CA);
		iso_8859_9_chars[0xCB] = (char) (0x00CB);
		iso_8859_9_chars[0xCC] = (char) (0x00CC);
		iso_8859_9_chars[0xCD] = (char) (0x00CD);
		iso_8859_9_chars[0xCE] = (char) (0x00CE);
		iso_8859_9_chars[0xCF] = (char) (0x00CF);
		iso_8859_9_chars[0xD0] = (char) (0x011E);
		iso_8859_9_chars[0xD1] = (char) (0x00D1);
		iso_8859_9_chars[0xD2] = (char) (0x00D2);
		iso_8859_9_chars[0xD3] = (char) (0x00D3);
		iso_8859_9_chars[0xD4] = (char) (0x00D4);
		iso_8859_9_chars[0xD5] = (char) (0x00D5);
		iso_8859_9_chars[0xD6] = (char) (0x00D6);
		iso_8859_9_chars[0xD7] = (char) (0x00D7);
		iso_8859_9_chars[0xD8] = (char) (0x00D8);
		iso_8859_9_chars[0xD9] = (char) (0x00D9);
		iso_8859_9_chars[0xDA] = (char) (0x00DA);
		iso_8859_9_chars[0xDB] = (char) (0x00DB);
		iso_8859_9_chars[0xDC] = (char) (0x00DC);
		iso_8859_9_chars[0xDD] = (char) (0x0130);
		iso_8859_9_chars[0xDE] = (char) (0x015E);
		iso_8859_9_chars[0xDF] = (char) (0x00DF);
		iso_8859_9_chars[0xE0] = (char) (0x00E0);
		iso_8859_9_chars[0xE1] = (char) (0x00E1);
		iso_8859_9_chars[0xE2] = (char) (0x00E2);
		iso_8859_9_chars[0xE3] = (char) (0x00E3);
		iso_8859_9_chars[0xE4] = (char) (0x00E4);
		iso_8859_9_chars[0xE5] = (char) (0x00E5);
		iso_8859_9_chars[0xE6] = (char) (0x00E6);
		iso_8859_9_chars[0xE7] = (char) (0x00E7);
		iso_8859_9_chars[0xE8] = (char) (0x00E8);
		iso_8859_9_chars[0xE9] = (char) (0x00E9);
		iso_8859_9_chars[0xEA] = (char) (0x00EA);
		iso_8859_9_chars[0xEB] = (char) (0x00EB);
		iso_8859_9_chars[0xEC] = (char) (0x00EC);
		iso_8859_9_chars[0xED] = (char) (0x00ED);
		iso_8859_9_chars[0xEE] = (char) (0x00EE);
		iso_8859_9_chars[0xEF] = (char) (0x00EF);
		iso_8859_9_chars[0xF0] = (char) (0x011F);
		iso_8859_9_chars[0xF1] = (char) (0x00F1);
		iso_8859_9_chars[0xF2] = (char) (0x00F2);
		iso_8859_9_chars[0xF3] = (char) (0x00F3);
		iso_8859_9_chars[0xF4] = (char) (0x00F4);
		iso_8859_9_chars[0xF5] = (char) (0x00F5);
		iso_8859_9_chars[0xF6] = (char) (0x00F6);
		iso_8859_9_chars[0xF7] = (char) (0x00F7);
		iso_8859_9_chars[0xF8] = (char) (0x00F8);
		iso_8859_9_chars[0xF9] = (char) (0x00F9);
		iso_8859_9_chars[0xFA] = (char) (0x00FA);
		iso_8859_9_chars[0xFB] = (char) (0x00FB);
		iso_8859_9_chars[0xFC] = (char) (0x00FC);
		iso_8859_9_chars[0xFD] = (char) (0x0131);
		iso_8859_9_chars[0xFE] = (char) (0x015F);
		iso_8859_9_chars[0xFF] = (char) (0x00FF);

		iso_8859_9_chars_ready = TRUE;
	}
}

void iso_8859_11_chars_init(){
	int i;
	if (iso_8859_11_chars_ready)
		return;
	else{
		for (i = 0; i < 128; i++)
		{
			iso_8859_11_chars[i] = (char) i;
		}
		for (i = 128; i < 256; i++)
		{
			iso_8859_11_chars[i] = (char) (0xfffd);
		}
		iso_8859_11_chars[0xA1] = (char) (0x0E01); //THAI CHARACTER KO KAI
		iso_8859_11_chars[0xA2] = (char) (0x0E02); //THAI CHARACTER KHO KHAI
		iso_8859_11_chars[0xA3] = (char) (0x0E03); //THAI CHARACTER KHO KHUAT
		iso_8859_11_chars[0xA4] = (char) (0x0E04); //THAI CHARACTER KHO KHWAI
		iso_8859_11_chars[0xA5] = (char) (0x0E05); //THAI CHARACTER KHO KHON
		iso_8859_11_chars[0xA6] = (char) (0x0E06); //THAI CHARACTER KHO RAKHANG
		iso_8859_11_chars[0xA7] = (char) (0x0E07); //THAI CHARACTER NGO NGU
		iso_8859_11_chars[0xA8] = (char) (0x0E08); //THAI CHARACTER CHO CHAN
		iso_8859_11_chars[0xA9] = (char) (0x0E09); //THAI CHARACTER CHO CHING
		iso_8859_11_chars[0xAA] = (char) (0x0E0A); //THAI CHARACTER CHO CHANG
		iso_8859_11_chars[0xAB] = (char) (0x0E0B); //THAI CHARACTER SO SO
		iso_8859_11_chars[0xAC] = (char) (0x0E0C); //THAI CHARACTER CHO CHOE
		iso_8859_11_chars[0xAD] = (char) (0x0E0D); //THAI CHARACTER YO YING
		iso_8859_11_chars[0xAE] = (char) (0x0E0E); //THAI CHARACTER DO CHADA
		iso_8859_11_chars[0xAF] = (char) (0x0E0F); //THAI CHARACTER TO PATAK
		iso_8859_11_chars[0xB0] = (char) (0x0E10); //THAI CHARACTER THO THAN
		iso_8859_11_chars[0xB1] = (char) (0x0E11); //THAI CHARACTER THO NANGMONTHO
		iso_8859_11_chars[0xB2] = (char) (0x0E12); //THAI CHARACTER THO PHUTHAO
		iso_8859_11_chars[0xB3] = (char) (0x0E13); //THAI CHARACTER NO NEN
		iso_8859_11_chars[0xB4] = (char) (0x0E14); //THAI CHARACTER DO DEK
		iso_8859_11_chars[0xB5] = (char) (0x0E15); //THAI CHARACTER TO TAO
		iso_8859_11_chars[0xB6] = (char) (0x0E16); //THAI CHARACTER THO THUNG
		iso_8859_11_chars[0xB7] = (char) (0x0E17); //THAI CHARACTER THO THAHAN
		iso_8859_11_chars[0xB8] = (char) (0x0E18); //THAI CHARACTER THO THONG
		iso_8859_11_chars[0xB9] = (char) (0x0E19); //THAI CHARACTER NO NU
		iso_8859_11_chars[0xBA] = (char) (0x0E1A); //THAI CHARACTER BO BAIMAI
		iso_8859_11_chars[0xBB] = (char) (0x0E1B); //THAI CHARACTER PO PLA
		iso_8859_11_chars[0xBC] = (char) (0x0E1C); //THAI CHARACTER PHO PHUNG
		iso_8859_11_chars[0xBD] = (char) (0x0E1D); //THAI CHARACTER FO FA
		iso_8859_11_chars[0xBE] = (char) (0x0E1E); //THAI CHARACTER PHO PHAN
		iso_8859_11_chars[0xBF] = (char) (0x0E1F); //THAI CHARACTER FO FAN
		iso_8859_11_chars[0xC0] = (char) (0x0E20); //THAI CHARACTER PHO SAMPHAO
		iso_8859_11_chars[0xC1] = (char) (0x0E21); //THAI CHARACTER MO MA
		iso_8859_11_chars[0xC2] = (char) (0x0E22); //THAI CHARACTER YO YAK
		iso_8859_11_chars[0xC3] = (char) (0x0E23); //THAI CHARACTER RO RUA
		iso_8859_11_chars[0xC4] = (char) (0x0E24); //THAI CHARACTER RU
		iso_8859_11_chars[0xC5] = (char) (0x0E25); //THAI CHARACTER LO LING
		iso_8859_11_chars[0xC6] = (char) (0x0E26); //THAI CHARACTER LU
		iso_8859_11_chars[0xC7] = (char) (0x0E27); //THAI CHARACTER WO WAEN
		iso_8859_11_chars[0xC8] = (char) (0x0E28); //THAI CHARACTER SO SALA
		iso_8859_11_chars[0xC9] = (char) (0x0E29); //THAI CHARACTER SO RUSI
		iso_8859_11_chars[0xCA] = (char) (0x0E2A); //THAI CHARACTER SO SUA
		iso_8859_11_chars[0xCB] = (char) (0x0E2B); //THAI CHARACTER HO HIP
		iso_8859_11_chars[0xCC] = (char) (0x0E2C); //THAI CHARACTER LO CHULA
		iso_8859_11_chars[0xCD] = (char) (0x0E2D); //THAI CHARACTER O ANG
		iso_8859_11_chars[0xCE] = (char) (0x0E2E); //THAI CHARACTER HO NOKHUK
		iso_8859_11_chars[0xCF] = (char) (0x0E2F); //THAI CHARACTER PAIYANNOI
		iso_8859_11_chars[0xD0] = (char) (0x0E30); //THAI CHARACTER SARA A
		iso_8859_11_chars[0xD1] = (char) (0x0E31); //THAI CHARACTER MAI HAN-AKAT
		iso_8859_11_chars[0xD2] = (char) (0x0E32); //THAI CHARACTER SARA AA
		iso_8859_11_chars[0xD3] = (char) (0x0E33); //THAI CHARACTER SARA AM
		iso_8859_11_chars[0xD4] = (char) (0x0E34); //THAI CHARACTER SARA I
		iso_8859_11_chars[0xD5] = (char) (0x0E35); //THAI CHARACTER SARA II
		iso_8859_11_chars[0xD6] = (char) (0x0E36); //THAI CHARACTER SARA UE
		iso_8859_11_chars[0xD7] = (char) (0x0E37); //THAI CHARACTER SARA UEE
		iso_8859_11_chars[0xD8] = (char) (0x0E38); //THAI CHARACTER SARA U
		iso_8859_11_chars[0xD9] = (char) (0x0E39); //THAI CHARACTER SARA UU
		iso_8859_11_chars[0xDA] = (char) (0x0E3A); //THAI CHARACTER PHINTHU
		iso_8859_11_chars[0xDF] = (char) (0x0E3F); //THAI CURRENCY SYMBOL BAHT
		iso_8859_11_chars[0xE0] = (char) (0x0E40); //THAI CHARACTER SARA E
		iso_8859_11_chars[0xE1] = (char) (0x0E41); //THAI CHARACTER SARA AE
		iso_8859_11_chars[0xE2] = (char) (0x0E42); //THAI CHARACTER SARA O
		iso_8859_11_chars[0xE3] = (char) (0x0E43); //THAI CHARACTER SARA AI MAIMUAN
		iso_8859_11_chars[0xE4] = (char) (0x0E44); //THAI CHARACTER SARA AI MAIMALAI
		iso_8859_11_chars[0xE5] = (char) (0x0E45); //THAI CHARACTER LAKKHANGYAO
		iso_8859_11_chars[0xE6] = (char) (0x0E46); //THAI CHARACTER MAIYAMOK
		iso_8859_11_chars[0xE7] = (char) (0x0E47); //THAI CHARACTER MAITAIKHU
		iso_8859_11_chars[0xE8] = (char) (0x0E48); //THAI CHARACTER MAI EK
		iso_8859_11_chars[0xE9] = (char) (0x0E49); //THAI CHARACTER MAI THO
		iso_8859_11_chars[0xEA] = (char) (0x0E4A); //THAI CHARACTER MAI TRI
		iso_8859_11_chars[0xEB] = (char) (0x0E4B); //THAI CHARACTER MAI CHATTAWA
		iso_8859_11_chars[0xEC] = (char) (0x0E4C); //THAI CHARACTER THANTHAKHAT
		iso_8859_11_chars[0xED] = (char) (0x0E4D); //THAI CHARACTER NIKHAHIT
		iso_8859_11_chars[0xEE] = (char) (0x0E4E); //THAI CHARACTER YAMAKKAN
		iso_8859_11_chars[0xEF] = (char) (0x0E4F); //THAI CHARACTER FONGMAN
		iso_8859_11_chars[0xF0] = (char) (0x0E50); //THAI DIGIT ZERO
		iso_8859_11_chars[0xF1] = (char) (0x0E51); //THAI DIGIT ONE
		iso_8859_11_chars[0xF2] = (char) (0x0E52); //THAI DIGIT TWO
		iso_8859_11_chars[0xF3] = (char) (0x0E53); //THAI DIGIT THREE
		iso_8859_11_chars[0xF4] = (char) (0x0E54); //THAI DIGIT FOUR
		iso_8859_11_chars[0xF5] = (char) (0x0E55); //THAI DIGIT FIVE
		iso_8859_11_chars[0xF6] = (char) (0x0E56); //THAI DIGIT SIX
		iso_8859_11_chars[0xF7] = (char) (0x0E57); //THAI DIGIT SEVEN
		iso_8859_11_chars[0xF8] = (char) (0x0E58); //THAI DIGIT EIGHT
		iso_8859_11_chars[0xF9] = (char) (0x0E59); //THAI DIGIT NINE
		iso_8859_11_chars[0xFA] = (char) (0x0E5A); //THAI CHARACTER ANGKHANKHU
		iso_8859_11_chars[0xFB] = (char) (0x0E5B); //THAI CHARACTER KHOMUT

		iso_8859_11_chars_ready = TRUE;
	}
}


