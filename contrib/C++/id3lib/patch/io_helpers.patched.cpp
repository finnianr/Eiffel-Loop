// $Id: io_helpers.cpp,v 1.13 2002/07/02 22:13:56 t1mpy Exp $

// id3lib: a C++ library for creating and manipulating id3v1/v2 tags
// Copyright 1999, 2000  Scott Thomas Haug

// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Library General Public License as published by
// the Free Software Foundation; either version 2 of the License, or (at your
// option) any later version.
//
// This library is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public
// License for more details.
//
// You should have received a copy of the GNU Library General Public License
// along with this library; if not, write to the Free Software Foundation,
// Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

// The id3lib authors encourage improvements and optimisations to be sent to
// the id3lib coordinator.  Please see the README file for details on where to
// send such submissions.  See the AUTHORS file for a list of people who have
// contributed to id3lib.  See the ChangeLog file for a list of changes to
// id3lib.  These files are distributed with id3lib at
// http://download.sourceforge.net/id3lib/

#if defined HAVE_CONFIG_H
#include <config.h>
#endif

#include "id3/io_decorators.h" //has "readers.h" "io_helpers.h" "utils.h"

using namespace dami;

String io::readString(ID3_Reader& reader)
{
  String str;
  while (!reader.atEnd())
  {
    ID3_Reader::char_type ch = reader.readChar();
    if (ch == '\0')
    {
      break;
    }
    str += static_cast<char>(ch);
  }
  return str;
}

String io::readText(ID3_Reader& reader, size_t len)
{
  String str;
  str.reserve(len);
  const size_t SIZE = 1024;
  ID3_Reader::char_type buf[SIZE];
  size_t remaining = len;
  while (remaining > 0 && !reader.atEnd())
  {
    size_t numRead = reader.readChars(buf, min(remaining, SIZE));
    remaining -= numRead;
    str.append(reinterpret_cast<String::value_type *>(buf), numRead);
  }
  return str;
}

namespace
{
  bool isNull(unsigned char ch1, unsigned char ch2)
  {
    return ch1 == '\0' && ch2 == '\0';
  }

  int isBOM(unsigned char ch1, unsigned char ch2)
  {
  // The following is taken from the following URL:
  // http://community.roxen.com/developers/idocs/rfc/rfc2781.html
  /* The Unicode Standard and ISO 10646 define the character "ZERO WIDTH
     NON-BREAKING SPACE" (0xFEFF), which is also known informally as
     "BYTE ORDER MARK" (abbreviated "BOM"). The latter name hints at a
     second possible usage of the character, in addition to its normal
     use as a genuine "ZERO WIDTH NON-BREAKING SPACE" within text. This
     usage, suggested by Unicode section 2.4 and ISO 10646 Annex F
     (informative), is to prepend a 0xFEFF character to a stream of
     Unicode characters as a "signature"; a receiver of such a serialized
     stream may then use the initial character both as a hint that the
     stream consists of Unicode characters and as a way to recognize the
     serialization order. In serialized UTF-16 prepended with such a
     signature, the order is big-endian if the first two octets are 0xFE
     followed by 0xFF; if they are 0xFF followed by 0xFE, the order is
     little-endian. Note that 0xFFFE is not a Unicode character,
     precisely to preserve the usefulness of 0xFEFF as a byte-order
     mark. */

    if (ch1 == 0xFE && ch2 == 0xFF)
    {
      return 1;
    }
    else if (ch1 == 0xFF && ch2 == 0xFE)
    {
      return -1;
    }
    return 0;
  }

  bool readTwoChars(ID3_Reader& reader, 
                    ID3_Reader::char_type& ch1, 
                    ID3_Reader::char_type& ch2)
  {
    if (reader.atEnd())
    {
      return false;
    }
    io::ExitTrigger et(reader);
    ch1 = reader.readChar();
    if (reader.atEnd())
    {
      return false;
    }
    et.release();
    ch2 = reader.readChar();
    return true;
  }
}

String io::readUnicodeString(ID3_Reader& reader)
{
  String unicode;
  ID3_Reader::char_type ch1, ch2;
  if (!readTwoChars(reader, ch1, ch2) || isNull(ch1, ch2))
  {
    return unicode;
  }
  int bom = isBOM(ch1, ch2);
  int bo_actual;

  if (!bom)
  {
    ID3D_NOTICE( "ID3_BOM::readUnicodeString(): Unicode has no BOM" );

    // The string is UTF-16 (Unicode) but with no Byte Order Marker (BOM).
    // Even though the Unicode standard says that big-endian should be assumed in the absence of
    // a BOM, it also says that this can be overriden by other concerns.  Some Windows software
    // authors appear to have interpreted this as meaning that Wintel's little-endianism
    // may override the presumption of big-endianism.  Others assume that it does not.
    // Files  may, therefore, contain either, and neither big- nor little-endian is a safe
    // assumption.
    // For western alphabets, most characters are represented by a zero as the most significant
    // byte.  A zero as the second byte, therefore, indicates strongly that the string is
    // little-endian.  There are only five cases in which this is not true - where the first byte is:
    //    00 00 - Null (reversible, "non-endian", terminates string)
    //    01 00 - Latin capital letter A with macron
    //    02 00 - Latin capital letter A with double grave 
    //    03 00 - Combining grave accent
    //    04 00 - Cyrillic capital letter IE with grave (U+0400)
    // The corresponding reversed characters are:
    //    00 01 - Start of Heading
    //    00 02 - Start of Text
    //    00 03 - End of Text
    //    00 04 - End of Transmission
    // None of these reversed characters are likely to occur in ID3 strings.
    // We can therefore safely improve on the big-endian assumption for strings without BOM
    // by recognising that if the second byte is zero, and the first byte is greater than 04,
    // then the string must be little-endian.
    // This modification does not address the missing BOM problem completely, because incorrectly
    // non-BOMd little-endian strings using non-western alphabets will still not be detected.
    // However, this method will not cause any "false positives" resulting in big-endian strings
    // being incorrectly reversed.

    if ( ( ch1 >= 4 ) && ( ch2 == 0) )
      // Probably little-endian
      {
      ID3D_NOTICE( "ID3_BOM::readUnicodeString(): Second char is zero: Probably little-endian" );
      bo_actual = -1;
      unicode += static_cast<char>(ch2);
      unicode += static_cast<char>(ch1);
      ID3D_NOTICE( "ID3_BOM::readUnicodeString(): Little-endian data read and stored as: " << static_cast<int>(ch2) << " " << static_cast<int>(ch1) );
      }
    else
      // Probably big-endian
      {
      ID3D_NOTICE( "ID3_BOM::readUnicodeString(): Second char is non-zero: Probably big-endian" );
      bo_actual = 1;
      unicode += static_cast<char>(ch1);
      unicode += static_cast<char>(ch2);
      ID3D_NOTICE( "ID3_BOM::readUnicodeString(): Big-endian data read and stored as: " << static_cast<int>(ch1) << " " << static_cast<int>(ch2) );
      }
  }
  else
  {
    bo_actual = bom;
  }
  while (!reader.atEnd())
  {
    if (!readTwoChars(reader, ch1, ch2) || isNull(ch1, ch2))
    {
      break;
    }
    if (bo_actual == -1)
    {
      unicode += static_cast<char>(ch2);
      unicode += static_cast<char>(ch1);
      ID3D_NOTICE( "ID3_BOM::readUnicodeString(): Little-endian data read and stored as: " << static_cast<int>(ch2) << " " << static_cast<int>(ch1) );
    }
    else
    {
      unicode += static_cast<char>(ch1);
      unicode += static_cast<char>(ch2);
      ID3D_NOTICE( "ID3_BOM::readUnicodeString(): Big-endian data read and stored as: " << static_cast<int>(ch1) << " " << static_cast<int>(ch2) );
    }
  }
  return unicode;
}

String io::readUnicodeText(ID3_Reader& reader, size_t len)
{
  String unicode;
  ID3_Reader::char_type ch1, ch2;
  if (!readTwoChars(reader, ch1, ch2))
  {
    return unicode;
  }
  len -= 2;
  ID3D_NOTICE( "ID3_BOM::readUnicodeText(): readUnicodeText entered" );
  int bom = isBOM(ch1, ch2);
  int bo_actual;
  if (!bom)
  {
    ID3D_NOTICE( "ID3_BOM::readUnicodeText(): Unicode has no BOM" );
    // See comment in readUnicodeString for description of method of detecting
    // little-endian UTF-16 strings that have no Byte Order Marker.
    if ( ( ch1 >= 4 ) && ( ch2 == 0) )
    {
      // Probably little-endian
      bo_actual = -1;
      ID3D_NOTICE( "ID3_BOM::readUnicodeText(): Second char is zero: Probably little-endian" );
      unicode += static_cast<char>(ch2);
      unicode += static_cast<char>(ch1);
      ID3D_NOTICE( "ID3_BOM::readUnicodeText(): Little-endian data read and stored as: " << static_cast<int>(ch2) << " " << static_cast<int>(ch1) );
    }
    else
    {
      // Probably big-endian
      bo_actual = 1;
      ID3D_NOTICE( "ID3_BOM::readUnicodeText(): Second char is non-zero: Probably big-endian" );
      unicode += ch1;
      unicode += ch2;
      ID3D_NOTICE( "ID3_BOM::readUnicodeText(): Big-endian data read and stored as: " << static_cast<int>(ch1) << " " << static_cast<int>(ch2) );
    }
  }
  else 
  {
      bo_actual = bom;
  }
  if (bo_actual == 1)
  {
    // BOM says big-endian or identified as big-endian
    unicode += readText(reader, len);
    ID3D_NOTICE( "ID3_BOM::readUnicodeText(): Big-endian data string read and stored" );
  }
  else
  {
    // BOM says little-endian or identified as little-endian
    for (size_t i = 0; i < len; i += 2)
    {
      if (!readTwoChars(reader, ch1, ch2))
      {
        break;
      }
      unicode += ch2;
      unicode += ch1;
      ID3D_NOTICE( "ID3_BOM::readUnicodeText(): Little-endian data read and stored as: " << static_cast<int>(ch2) << " " << static_cast<int>(ch1) );
    }
  }
  return unicode;
}

BString io::readAllBinary(ID3_Reader& reader)
{
  return readBinary(reader, reader.remainingBytes());
}

BString io::readBinary(ID3_Reader& reader, size_t len)
{
  BString binary;
  binary.reserve(len);
  
  size_t remaining = len;
  const size_t SIZE = 1024;
  ID3_Reader::char_type buf[SIZE];
  while (!reader.atEnd() && remaining > 0)
  {
    size_t numRead = reader.readChars(buf, min(remaining, SIZE));
    remaining -= numRead;
    binary.append(reinterpret_cast<BString::value_type *>(buf), numRead);
  }
  
  return binary;
}

uint32 io::readLENumber(ID3_Reader& reader, size_t len)
{
  uint32 val = 0;
  for (size_t i = 0; i < len; i++)
  {
    if (reader.atEnd())
    {
      break;
    }
    val += (static_cast<uint32>(0xFF & reader.readChar()) << (i * 8));
  }
  return val;
}

uint32 io::readBENumber(ID3_Reader& reader, size_t len)
{
  uint32 val = 0;
  
  for (ID3_Reader::size_type i = 0; i < len && !reader.atEnd(); ++i)
  {
    val *= 256; // 2^8
    val += static_cast<uint32>(0xFF & reader.readChar());
  }
  return val;
}

String io::readTrailingSpaces(ID3_Reader& reader, size_t len)
{
  io::WindowedReader wr(reader, len);
  String str;
  String spaces;
  str.reserve(len);
  spaces.reserve(len);
  while (!wr.atEnd())
  {
    ID3_Reader::char_type ch = wr.readChar();
    if (ch == '\0' || ch == ' ')
    {
      spaces += ch;
    }
    else
    {
      str += spaces + (char) ch;
      spaces.erase();
    }
  }
  return str;
}

uint32 io::readUInt28(ID3_Reader& reader)
{
  uint32 val = 0;
  const unsigned short BITSUSED = 7;
  const uint32 MAXVAL = MASK(BITSUSED * sizeof(uint32));
  // For each byte of the first 4 bytes in the string...
  for (size_t i = 0; i < sizeof(uint32); ++i)
  {
    if (reader.atEnd())
    {
      break;
    }
    // ...append the last 7 bits to the end of the temp integer...
    val = (val << BITSUSED) | static_cast<uint32>(reader.readChar()) & MASK(BITSUSED);
  }

  // We should always parse 4 characters
  return min(val, MAXVAL);
}

size_t io::writeBENumber(ID3_Writer& writer, uint32 val, size_t len)
{
  ID3_Writer::char_type bytes[sizeof(uint32)];
  ID3_Writer::size_type size = min<ID3_Reader::size_type>(len, sizeof(uint32));
  renderNumber(bytes, val, size);
  return writer.writeChars(bytes, size);
}

size_t io::writeTrailingSpaces(ID3_Writer& writer, String buf, size_t len)
{
  ID3_Writer::pos_type beg = writer.getCur();
  ID3_Writer::size_type strLen = buf.size();
  ID3_Writer::size_type size = min((unsigned int)len, (unsigned int)strLen);
  writer.writeChars(buf.data(), size);
  for (; size < len; ++size)
  {
    writer.writeChar('\0');
  }
  return writer.getCur() - beg;
}

size_t io::writeUInt28(ID3_Writer& writer, uint32 val)
{
  uchar data[sizeof(uint32)];
  const unsigned short BITSUSED = 7;
  const uint32 MAXVAL = MASK(BITSUSED * sizeof(uint32));
  val = min(val, MAXVAL);
  // This loop renders the value to the character buffer in reverse order, as 
  // it is easy to extract the last 7 bits of an integer.  This is why the
  // loop shifts the value of the integer by 7 bits for each iteration.
  for (size_t i = 0; i < sizeof(uint32); ++i)
  {
    // Extract the last BITSUSED bits from val and put it in its appropriate
    // place in the data buffer
    data[sizeof(uint32) - i - 1] = static_cast<uchar>(val & MASK(BITSUSED));

    // The last BITSUSED bits were extracted from the val.  So shift it to the
    // right by that many bits for the next iteration
    val >>= BITSUSED;
  }
  
  // Should always render 4 bytes
  return writer.writeChars(data, sizeof(uint32));
}

size_t io::writeString(ID3_Writer& writer, String data)
{
  size_t size = writeText(writer, data);
  writer.writeChar('\0');
  return size + 1;
}

size_t io::writeText(ID3_Writer& writer, String data)
{
  ID3_Writer::pos_type beg = writer.getCur();
  writer.writeChars(data.data(), data.size());
  return writer.getCur() - beg;
}

size_t io::writeUnicodeString(ID3_Writer& writer, String data, bool bom)
{
  size_t size = writeUnicodeText(writer, data, bom);
  unicode_t null = NULL_UNICODE;
  writer.writeChars((const unsigned char*) &null, 2);
  return size + 2;
}

size_t io::writeUnicodeText(ID3_Writer& writer, String data, bool bom)
{
  ID3_Writer::pos_type beg = writer.getCur();
  size_t size = (data.size() / 2) * 2;
  if (size == 0)
  {
    return 0;
  }
  if (bom)
  {
    // Write the BOM: 0xFEFF
    unicode_t BOM = 0xFEFF;
    writer.writeChars((const unsigned char*) &BOM, 2);
    for (size_t i = 0; i < size; i += 2)
    {
      unicode_t ch = (data[i] << 8) | data[i+1];
      writer.writeChars((const unsigned char*) &ch, 2);
    }
  }
  return writer.getCur() - beg;
}

