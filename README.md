# UnicodeCCount
This is a wish-list of things I would like to add to [UnicodeCCount](http://scripts.sil.org/UnicodeCharacterCount). The original author would likely consider these features as project creep. So, it is likely up to me to do this, so here is to ... Someday. I am not a `perl` programer, but as I have used this tool, there are some things which I wish it did, and other things which I wish it did a little differently.

* There are other canonical equivalences in Unicode (ie. FCC + FCD). - I wish there was a flag which enabled these, flags for NFC and NFD already exist. See: http://perldoc.perl.org/5.8.8/Unicode/Normalize.html for a perl centric discussion.
* I wish there was a flag to not count characters, but count functional units. That is a third file would be needed but then based on that file (listing a set of strings), functional units could be counted. I have a prototype script in a github repo.
* I wish there was a flag for applying the Unicode related perl function `lc` to the input. See discussion here: http://perldoc.perl.org/functions/lc.html :: http://perl.about.com/od/programmingperl/qt/perllcfunction.htm
  * It would be good to also create a paired output - so order based on upper-lower case pairing rather than say Unicode ordering.
* I wish sometimes that the Unicode NAME for a character was also avaible via a column.
* I wish that a list of scripts from which characters are present in the text input could be output, with those script's IDs.
* I wish that tabs (and in general characters which do not have glyphs) were not returned without glyphs. I think there are two flags needed here. One flag for just `tab` related issues, and one for all grahemeless characters. Tab is epecially difficult, if the output of UCC is desired to be used as a data file, reading the file as a tab seperated file is problematic when the character output is also a tab. Other graphemeless characters are just difficult to read without the Unicode names or without a unique glyph.

The following is a list of some characters and the glyphs that Unicode has registerd for them: 
```
&#x0001;,␁
&#x0002;,␂
&#x0003;,␃
&#x0004;,␄
&#x0005;,␅
&#x0006;,␆
&#x0007;,␇
&#x0008;,␈
&#x000B;,␋
&#x000C;,␌
&#x000E;,␎
&#x000F;,␏
&#x0010;,␐
&#x0011;,␑
&#x0012;,␒
&#x0013;,␓
&#x0014;,␔
&#x0015;,␕
&#x0016;,␖
&#x0017;,␗
&#x0018;,␘
&#x0019;,␙
&#x001A;,␚
&#x001B;,␛
&#x00B1;,±
&#x001C;,␜
&#x001D;,␝
&#x001E;,␞
&#x001F;,␟
&#x0000;,␀
&#x000A;,␊
&#x000D;,␍
&#x0009;,␉
&#x007F;,␡
&#x00A7;,§
&#x0026;,&
&#x003C;,<
&#x003E;,>
&#x00A0;,␠
&#x1;,␁
&#x2;,␂
&#x3;,␃
&#x4;,␄
&#x5;,␅
&#x6;,␆
&#x7;,␇
&#x8;,␈
&#xB;,␋
&#xC;,␌
&#xE;,␎
&#xF;,␏
&#x10;,␐
&#x11;,␑
&#x12;,␒
&#x13;,␓
&#x14;,␔
&#x15;,␕
&#x16;,␖
&#x17;,␗
&#x18;,␘
&#x19;,␙
&#x1A;,␚
&#x1B;,␛
&#xB1;,±
&#x7F;,␡
&#xA7;,§
&#x26;,&
&#x22;,"
&#x3C;,<
&#x3E;,>
&#xA0;,␠
&#x1C;,␜
&#x1D;,␝
&#x1E;,␞
&#x1F;,␟
&#x0;,␀
&#xA;,␊
&#xD;,␍
&#x9;,␉
```
