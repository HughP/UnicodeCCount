# UnicodeCCount
This is a wish-list of things I would like to add to [UnicodeCCount](http://scripts.sil.org/UnicodeCharacterCount). The original author would likely consider these features as project creep. So, it is likely up to me to do this, so here is to ... Someday. I am not a `perl` programer, but as I have used this tool, there are some things which I wish it did, and other things which I wish it did a little differently.

## Additional canonical equivalences
* There are other canonical equivalences in Unicode (ie. FCC + FCD). - I wish there was a flag which enabled these, flags for NFC and NFD already exist. See: http://perldoc.perl.org/5.8.8/Unicode/Normalize.html for a perl centric discussion.
  * This would allow for the proper ordering of diacritics with the same tool as is used to count characters. So if we needed to pre-flight a document for another process we could use UnicodeCCount.
 
## Using a third argument as a reference to a data set
* I wish there was a flag that permitted the count functional units (sets of unicode codepoints that orthography users think of as a single unit). That is a third file would be needed but then based on that file (listing a set of strings), functional units could be counted. I have a prototype script in a github repo.
* I wish there was also a custom colation order. Two useful usecases I can think of would be:
  * segmentation based on colation order of the local of the language of the data one is working with, and
  * segmentation based on the typology of characters presented in Unicode report #tr35. 
   For instance I was looking at [Masai on ScriptSource](http://scriptsource.org/cms/scripts/page.php?item_id=wrSys_detail_sym&key=mas-Latn) and noticed that there are "main characters", "Auxiliary characters", and "index characters". Auxiliary and Index characters are informally defined in https://www.unicode.org/reports/tr35/tr35-general.html#Exemplars Index characters are more fully described: http://unicode.org/reports/tr35/tr35-collation.html#Index_Characters. Basically, an index character list just defines a useful set of buckets. Note that index characters are, by definition, in local collation order, but they do not define -- nor could they be used to deduce -- the full collation details. You can see that by recognizing that "A D G J M P S V Y" would be a valid (if uncommon) index character list for English. Similarly, for the Masai example, there are lots of characters in the "Main characters used" than are in the "Index characters use" lists -- you'd have to know how to collate Masai to put things into the buckets defined by the index.  
   Ideally such an implementation would be based on the Unicode Collation Algorithm (which is available from Perl), using tailoring to get what you wanted.  

   `do the UnicodCCount thing according to all indicated options;`  
       `order output according to order in file $_`  

    something on the command line like:  

    `CCount -m -s sortorderfile.txt -o outputfile.txt input.txt`  

   My use case for this has been to ingest files in languages and then to check those files against the characters in the "orthography" and the characters on the keyboard for that language. If the documents show that authors are using characters which are not "in their orthography" and are also "produced by their keyboard" then I have been taking note of that for my keyboard layout work.  
   
## Non-conatinive pairing
* In tonal languages which represent their tone via diacritics, it is often the case that these languages have tonal patterns which are phonologically important. That is, the sequence of diacritics across the tops of vowels is important just as much as digraphs or trigraphs. So, How can we comput if these exists? if we have the types of tonal patterns (also known as melodies) in a list, then it makes sense to be able to count these as functional units. (and across how many characters the melody occurs.) something like: find diacritic then length($string) to next vowel to match the next melody pattern. (On this point it might be good for me to look at the following tutorials [1](http://perlmaven.com/string-functions-length-lc-uc-index-substr) & [2](http://www.pageresource.com/cgirec/ptut13.htm))

## Chomp formating
* I wish there was a flag for applying the Unicode related perl function `lc` to the input. See discussion here: http://perldoc.perl.org/functions/lc.html :: http://perl.about.com/od/programmingperl/qt/perllcfunction.htm
  * It would be good to also create a paired output - so order based on upper-lower case pairing rather than say Unicode ordering.
  
## Output clarifications  
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
