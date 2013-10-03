#!/usr/bin/env perl
use strictures;
use Plack::Request;
use Plack::Builder;
use Plack::App::File;
use Encode;
use Path::Tiny;
use File::Spec;

my $self_file = path( File::Spec->rel2abs(__FILE__) );

my $template = do { local $/; <DATA> };

my $page = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    # my $text = encode_entities(decode("UTF-8",$req->parameters->{text} || ""), "><&");
    my $length = length($template);
    [ 200, [ "Content-Type" => "text/html; charset=utf-8" ],
      [ encode("UTF-8",$template) ] ];
};

builder {
    mount "/cardiacmraxial.dcm" => Plack::App::File->new(file => path($self_file->parent->parent, "fixture/cardiacmraxial.dcm"))->to_app;
    mount "/" => $page;
};

__DATA__
<html><head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <title>OHAI</title>
   <meta name="viewport" content="width=device-width, initial-scale=1" />
   <link type="text/css" href="http://code.jquery.com/mobile/latest/jquery.mobile.min.css" rel="stylesheet" />
   <style>
* {
    font-family:'Helvetica Neue', Arial, Helvetica, 'Liberation Sans', FreeSans, sans-serif;
    font-family: "Gill Sans", "Gill Sans MT", Calibri, sans-serif;
}
img {
  border:1px solid black;
}
   </style>
</head>
<body>
<h1 style="font-size:1em;font-weight:normal">center == brightness == level<br />
   width == contrast == window </h1>
<p>
<script type="text/javascript">
// After http://www.javascripter.net/faq/trim.htm
if (!String.prototype.trim) {
        String.prototype.trim = function() {
                return this.replace(/^\s+|\s+$/g,'');
        }
}

// From "http://stackoverflow.com/questions/7370943/retrieving-binary-file-content-using-javascript-base64-encode-it-and-reverse-de"

function base64Encode(str) {
    var CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var out = "", i = 0, len = str.length, c1, c2, c3;
    while (i < len) {
        c1 = str.charCodeAt(i++) & 0xff;
        if (i == len) {
            out += CHARS.charAt(c1 >> 2);
            out += CHARS.charAt((c1 & 0x3) << 4);
            out += "==";
            break;
        }
        c2 = str.charCodeAt(i++);
        if (i == len) {
            out += CHARS.charAt(c1 >> 2);
            out += CHARS.charAt(((c1 & 0x3)<< 4) | ((c2 & 0xF0) >> 4));
            out += CHARS.charAt((c2 & 0xF) << 2);
            out += "=";
            break;
        }
        c3 = str.charCodeAt(i++);
        out += CHARS.charAt(c1 >> 2);
        out += CHARS.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
        out += CHARS.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6));
        out += CHARS.charAt(c3 & 0x3F);
    }
    return out;
}


// After "https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Sending_and_Receiving_Binary_Data?redirectlocale=en-US&redirectslug=DOM%2FXMLHttpRequest%2FSending_and_Receiving_Binary_Data"
// modified for Microsoft per Ajax for Dummies, refactored for single return ... TBD. make asynchronous :(

function load_binary_resource(url) {
        var responseText = "";
        var req = false;
        if (window.XMLHttpRequest) {
                req = new XMLHttpRequest();
        }
        else if (window.ActiveXObject) {
                req = new ActiveXObject("Microsoft.XMLHTTP");
                //req = new ActiveXObject("MSXML2.XMLHTTP.3.0");
                //req = new ActiveXObject("MSXML2.XMLHTTP");

        }
        if (req) {
                req.open('GET', url, false);
                var useResponseText = false;
                if (req.overrideMimeType) {
                        //XHR binary charset opt by Marcus Granado 2006 [http://mgran.blogspot.com] ("http://web.archive.org/web/20071103070418/http://mgran.blogspot.com/2006/08/downloading-binary-streams-with.html")
                        req.overrideMimeType('text\/plain; charset=x-user-defined');
                        useResponseText = true;
                }
                // else not supported, e.g. IE after IE 7 :(
                req.send(null); // Mozilla will fail at this point if test is from a file rather than an http server, and URL is not relative (security reasons) ... see "http://stackoverflow.com/questions/2060551/xmlhttprequest-to-get-http-response-from-remote-host"
                if (req.status == 200 && req.readyState == 4) {
                        //alert("Success status");
                        if (useResponseText) {
                                responseText = req.responseText;
                        }
                        else if (typeof(req.responseBody) !== 'undefined' && VBArray) {
                                // Hmmm ... from hints at "http://stackoverflow.com/questions/1919972/how-do-i-access-xhr-responsebody-for-binary-data-from-javascript-in-ie"
                                //alert("Trying req.responseBody with VBArray");
                                var asArray = new VBArray(req.responseBody).toArray();
                                if (asArray && asArray.length > 0) {
                                        //alert("asArray.length  = "+asArray.length);
                                        // This is super slow, but at least it works :(
                                        for (var i=0; i<asArray.length; ++i) {
                                                responseText += String.fromCharCode(asArray[i]);
                                        }
                                }
                        }
                }
        }
        return responseText;
}

function getUint16LE(filestream,offset) {
        return (filestream.charCodeAt(offset) & 0xff) + ((filestream.charCodeAt(offset+1) & 0xff) << 8);
}

function getUint32LE(filestream,offset) {
        return ((filestream.charCodeAt(offset) & 0xff) + ((filestream.charCodeAt(offset+1) & 0xff) << 8) + ((filestream.charCodeAt(offset+2) & 0xff) << 16) + ((filestream.charCodeAt(offset+3) & 0xff) << 24)) >>> 0 /* unsigned shift to make sure it is a Unit32 per "http://www.2ality.com/2012/02/js-integers.html", else 0xffffffff becomes -1 */;
}

function explicitVRIsLongValueLengthForm(vr) {
        return vr === "UN" || vr === "OB" || vr === "OW" || vr === "OF" || vr === "OD" || vr === "SQ";
}

function PixelDataInformation(samplesPerPixel,photometricInterpretation,rows,columns,bitsAllocated,bitsStored,highBit,numberOfFrames,windowCenter,windowWidth,pixelDataOffset,pixelDataLength) {
        this.samplesPerPixel = samplesPerPixel;
        this.photometricInterpretation = photometricInterpretation;
        this.rows = rows;
        this.columns = columns;
        this.bitsAllocated = bitsAllocated;
        this.bitsStored = bitsStored;
        this.highBit = highBit;
        this.numberOfFrames = numberOfFrames;
        this.windowCenter = windowCenter;
        this.windowWidth = windowWidth;
        this.rescaleSlope = 1;
        this.rescaleIntercept = 0;
        this.signed = false;
        this.inverted = false;
        this.pixelDataOffset = pixelDataOffset;
        this.pixelDataLength = pixelDataLength;
}

function makeWindowLUT(pixelDataInformation) {
        var lut = [];

        // copied from com.pixelmed.display.WindowCenterWidth.java ...

        var ymin = 0;
        var ymax = 255;
        var yrange = ymax - ymin;

        var cmp5 = pixelDataInformation.windowCenter - 0.5;
        var wm1 = pixelDataInformation.windowWidth - 1.0;

        document.write( "<p>windowCenter " + pixelDataInformation.windowCenter + "<br />" );
        document.write( "windowWidth " + pixelDataInformation.windowWidth + "</p>");

        // 321
        // cmp5 = -100 - 0.5; // actual center is 228
        // wm1 = 446 - 1.0; // actual width is 446

        var halfwm1 = wm1/2.0;
        var bottom = cmp5 - halfwm1;
        var top = cmp5 + halfwm1;

        var startx = 0;
        var endx = 0;
        var lut = [];
        var mask = 0;

        if (pixelDataInformation.bitsStored > 8) {
                startx = pixelDataInformation.signed ? -32768 : 0;
                endx   = pixelDataInformation.signed ?  32768 : 65536;
                lut.length = 65536;
                mask=0xffff;
        }
        else {
                startx = pixelDataInformation.signed ? -128 : 0;
                endx   = pixelDataInformation.signed ?  128 : 256;
                lut.length = 256;
                mask=0xff;
        }

        for (var xi=startx; xi<endx; ++xi) {
                var x = xi * pixelDataInformation.rescaleSlope + pixelDataInformation.rescaleIntercept;
                var y;
                if (x <= bottom)  y = ymin;
                else if (x > top) y = ymax;
                else {
                        y = ((x-cmp5)/wm1 + 0.5)*yrange+ymin;
                }
                if (pixelDataInformation.inverted) y = ymax-y;
                lut[xi&mask]=y;
        }
        //if (usePad) {
        //      applyPaddingValueRangeToLUT(lut,pad,padRangeLimit,mask);
        //}
        return lut;
}

function dumpObjectAsString(object) {
        // After "http://stackoverflow.com/questions/957537/how-can-i-print-a-javascript-object"
        var output = "";
        for (property in object) {
                output += property + ': ' + object[property]+'; ';
        }
        return output;
}

function parseDICOMDataElements(filestream,offset) {
        var samplesPerPixel = 1;
        var photometricInterpretation = "";
        var rows = 0;
        var columns = 0;
        var bitsAllocated = 0;
        var bitsStored = 0;
        var highBit = 0;
        var numberOfFrames = 1;
        var windowCenter = 0;
        var windowWidth = 0;
        var pixelDataOffset = 0;
        var pixelDataLength = 0;

        var littleEndian = true;
        while (offset < filestream.length) {
                var group = getUint16LE(filestream,offset);
                offset+=2;
                var element = getUint16LE(filestream,offset);
                offset+=2;
                var vr = "";
                var vl = 0;
                if (group == 0xfffe) {
                        // no VR for Sequence Item and Delimiter tags, and always 4 byte length
                        vl = getUint32LE(filestream,offset);
                        offset+=4;
                }
                else {
                        vr = filestream.substring(offset,offset+2);
                        offset+=2;
                        if (explicitVRIsLongValueLengthForm(vr)) {
                                offset+=2;      // skip reserved bytes
                                vl = getUint32LE(filestream,offset);
                                offset+=4;
                        }
                        else {
                                vl = getUint16LE(filestream,offset);
                                offset+=2;
                        }
                }
                //console.log("Parsed (0x"+group.toString(16)+",0x"+element.toString(16)+") "+vr+" vl=0x"+vl.toString(16)+" ("+vl+" dec)");
                if (vl != 0xffffffff && vl != -1) {             // check both just be 100% certain, in case gets sign extended
                        if (group == 0x0028) {
                                if (vr === "US" && vl == 2) {
                                        var value = getUint16LE(filestream,offset);             // do not bump offset; done later for all elements
                                        switch (element) {
                                                case 0x0002:    samplesPerPixel = value; break;
                                                case 0x0008:    numberOfFrames = value; break;
                                                case 0x0010:    rows = value; break;
                                                case 0x0011:    columns = value; break;
                                                case 0x0100:    bitsAllocated = value; break;
                                                case 0x0101:    bitsStored = value; break;
                                                case 0x0102:    highBit = value; break;
                                        }
                                }
                                else if (vr === "CS" && element == 0x0004 && vl > 0) {
                                        photometricInterpretation = filestream.substring(offset,offset+vl).trim();      // Don't forget to remove even padding spaces
                                }
                                else if (vr === "DS" && vl > 0) {
                                        var value = parseFloat(filestream.substring(offset,offset+vl).trim());          // do not bump offset; done later for all elements
                                        switch (element) {
                                                case 0x1050:    windowCenter = value; break;
                                                case 0x1051:    windowWidth = value; break;
                                        }
                                }
                        }
                        else if (group == 0x7fe0 && element == 0x0010) {
                                pixelDataOffset = offset;
                                pixelDataLength = vl;
                        }
                        offset += vl;
                }
                //else {
                //      console.log("Ignoring undefined length");
                //}
        }
        //alert("photometricInterpretation = "+photometricInterpretation);
        //alert("rows = "+rows);

        var pixelDataInformation = null;
        if (pixelDataLength > 0 && rows > 0 && columns > 0) {
                // could guess bitsAllocated, etc., here if missing, but for simplicity assume correct ...
                if ((bitsAllocated == 8 || bitsAllocated == 16) && bitsStored > 0 && highBit == (bitsStored-1)
                  && (samplesPerPixel == 1 && photometricInterpretation === "MONOCHROME2")) {
                        pixelDataInformation = new PixelDataInformation(samplesPerPixel,photometricInterpretation,rows,columns,bitsAllocated,bitsStored,highBit,numberOfFrames,windowCenter,windowWidth,pixelDataOffset,pixelDataLength);
                }
        }
        return pixelDataInformation;
}

// After http://emergent.unpythonic.net/software/01126462511-glif

function BlockedBitstream() {
    //this.base64Data = "";
    this.data = "";
        this.dataBlock = "";
        this.nextByteBeingBuilt = 0;
        this.nextAvailableBit = 0;

        this.addBit = function (sourceBit) {
                var useBit = sourceBit << this.nextAvailableBit;
                this.nextByteBeingBuilt = this.nextByteBeingBuilt | useBit;
                ++this.nextAvailableBit;
                if (this.nextAvailableBit > 7) {
                        //alert("Completed nextByteBeingBuilt 0x"+this.nextByteBeingBuilt.toString(16));
                        this.dataBlock += String.fromCharCode(this.nextByteBeingBuilt);
                        if (this.dataBlock.length > 123) {
                                var lengthPlusBlock = String.fromCharCode(this.dataBlock.length) + this.dataBlock;
                                // now will be 124 bytes, which is multiple of 3 and suitable for Base64 encoding
                                //this.base64Data += base64Encode(lengthPlusBlock);
                                this.data += lengthPlusBlock;
                                this.dataBlock = "";
                        }
                        this.nextByteBeingBuilt = 0;
                        this.nextAvailableBit = 0;
                }
        }

        this.add8BitByteAs9BitCode = function (sourceByte) {
                //alert("Adding byte 0x"+sourceByte.toString(16));
                for (i=0; i<8; ++i) {
                        this.addBit(sourceByte & 0x01);
                        sourceByte = sourceByte>>1;
                }
                this.addBit(0);
        }

        this.addClearCode = function () {
                //alert("Adding clear code");
                for (i=0; i<8; ++i) {
                        this.addBit(0);
                }
                this.addBit(1);
        }

        this.addEndOfInformationCode = function () {
                this.addBit(1);
                for (i=0; i<7; ++i) {
                        this.addBit(0);
                }
                this.addBit(1);
        }

        this.finish = function () {
                if (this.nextAvailableBit > 0) {
                        this.dataBlock += String.fromCharCode(this.nextByteBeingBuilt);
                }
                var lengthPlusBlock = String.fromCharCode(this.dataBlock.length) + this.dataBlock + "\x00" /* zero length sub-block signalling end of sub-blocks */ + "\x3b" /* GIF trailer */;
                // make the length a multiple of 3 or Base64 encoding will fail
                //while (lengthPlusBlock.length % 3 != 0) {
                //      lengthPlusBlock += "\x00";
                //}
                //this.base64Data += base64Encode(lengthPlusBlock);
                this.data += lengthPlusBlock;
                this.dataBlock = null;
                // cannot add any more than after this ... base64Data is complete
        }
}

function makeGIFFromDICOM(filestream,pixelDataInformation) {
        var imageWidthAndHeight =
                          String.fromCharCode(pixelDataInformation.columns%256) + String.fromCharCode(pixelDataInformation.columns/256) // width
                        + String.fromCharCode(pixelDataInformation.rows%256)    + String.fromCharCode(pixelDataInformation.rows/256)    // height
                        ;
        var gif = "GIF89a"
                + imageWidthAndHeight   // Logical Screen Size
                        + "\xff"                                // Flags ... Global Color Table present, Color Resolution 2^8, Sorted, Size of Global Color Table 2^8
                        + "\x00"                                // Background Color Index
                        + "\x00"                                // Pixel Aspect Ratio absent
                        ;
        // Create Global Color Table with r, g, b entries equal to index (grayscale table)
        for (i=0; i<256; ++i) {
                var rgbValue = String.fromCharCode(i);
                gif += rgbValue + rgbValue + rgbValue;
        }
        // Image Descriptor
        gif += "\x2c"                   // Image Separator
             + "\x00" + "\x00"  // Image Left Position
             + "\x00" + "\x00"  // Image Top Position
                 + imageWidthAndHeight
                 + "\x00"                       // Flags ... No Local Color Table, Not Interlaced, Not Sorted, Reserved 2 bits, Size of Local Color Table 0
                 ;

        gif += "\x08";                  // LZW code size is 8 bits (so each emitted code will be 9 bits)

        // we are going to write as many blocks are as necessary ... block size is max 2^8 (256) and we will use 128 source bytes since expanding to 9 bits ...

        var windowLUT = (pixelDataInformation.windowWidth >= 1) ? makeWindowLUT(pixelDataInformation) : null;

        var isWordPixel = pixelDataInformation.bitsAllocated == 16;
        var blockedBitstream = new BlockedBitstream();
        var sourceByteOffset = pixelDataInformation.pixelDataOffset;
        var sourceByteCount = 0;
        var outputByteCount = 0;
        while (sourceByteCount < pixelDataInformation.pixelDataLength) {
                if (outputByteCount % 128 == 0) {
                        blockedBitstream.addClearCode();
                }
                var outputByte;
                if (isWordPixel) {
                        outputByte = filestream.charCodeAt(sourceByteOffset) & 0xff;
                        ++sourceByteCount;
                        ++sourceByteOffset;
                        outputByte |= (filestream.charCodeAt(sourceByteOffset) & 0xff) << 8;
                        ++sourceByteCount;
                        ++sourceByteOffset;
                        if (windowLUT) {
                                outputByte = windowLUT[outputByte];
                        }
                        else {
                                outputByte >>>= (pixelDataInformation.bitsStored - 8);  // no window information ... just use most significant 8 bits
                        }
                }
                else {
                        outputByte = filestream.charCodeAt(sourceByteOffset);
                        ++sourceByteCount;
                        ++sourceByteOffset;
                }
                blockedBitstream.add8BitByteAs9BitCode(outputByte);
                ++outputByteCount;
        }
        blockedBitstream.addEndOfInformationCode();
        blockedBitstream.finish();

        filestream = null;      // no longer need it

        //return "data:image/gif;base64," + blockedBitstream.base64Data;
        return "data:image/gif;base64," + base64Encode(gif + blockedBitstream.data);
}

function loadTestFile() {
        var asGIF = null;
        //var url = "http://127.0.0.1:7091/?requestType=WADO&contentType=application/dicom&studyUID=1.3.6.1.4.1.5962.1.2.0.1372431750.1975.0&seriesUID=1.3.6.1.4.1.5962.1.3.0.0.1372431750.1975.0&objectUID=1.3.6.1.4.1.5962.1.1.0.0.0.1372431750.1975.0";
        //var url = "./1.3.6.1.4.1.5962.1.1.0.0.0.1372431750.1975.0.dcm";
        //var url = "smpte8.dcm";
        //var url = "smpte12nowindow.dcm";
        // dcsmpte -bits 12 -minval 74 -maxval 999 -r WindowWidth 925 -r WindowCenter 536.5 smpte12withwindow.dcm
        //var url = "smpte12withwindow.dcm";
        var url = "cardiacmraxial.dcm";


        //alert("About to load DICOM file");
        var filestream = load_binary_resource(url);
        //alert("Loaded DICOM file");
        //var abyte = filestream.charCodeAt(x) & 0xff; // throw away high-order byte (f7)

        if (filestream != null) {
                if (filestream.length > 0) {
                        //alert(filestream.length);
                        //alert(filestream.charAt(128)+" "+filestream.charCodeAt(128));
                        if (filestream.charAt(128) == 'D'
                         && filestream.charAt(129) == 'I'
                         && filestream.charAt(130) == 'C'
                         && filestream.charAt(131) == 'M') {
                                //alert("Have DICOM file ... parsing it ...");
                                var pixelDataInformation = parseDICOMDataElements(filestream,132);
                                if (pixelDataInformation != null) {
                                        //alert(dumpObjectAsString(pixelDataInformation));
                                        asGIF = makeGIFFromDICOM(filestream,pixelDataInformation);
                                        //alert("back from makeGIFFromDICOM(): length of string = "+asGIF.length);
                                        //console.log(asGIF);

                                        //var binaryGIF = load_binary_resource("./crap.gif");
                                        //asGIF = "data:image/gif;base64," + base64Encode(binaryGIF);
                                        //alert("crap.gif: length of string = "+asGIF.length);

                                        //asGIF = "data:image/gif;base64, iVBORw0KGgoAAAANSUhEUgAAABYAAAAQCAIAAACdjxhxAAAC7mlDQ1BJQ0MgUHJvZmlsZQAAeAGFVM9rE0EU/jZuqdAiCFprDrJ4kCJJWatoRdQ2/RFiawzbH7ZFkGQzSdZuNuvuJrWliOTi0SreRe2hB/+AHnrwZC9KhVpFKN6rKGKhFy3xzW5MtqXqwM5+8943731vdt8ADXLSNPWABOQNx1KiEWlsfEJq/IgAjqIJQTQlVdvsTiQGQYNz+Xvn2HoPgVtWw3v7d7J3rZrStpoHhP1A4Eea2Sqw7xdxClkSAog836Epx3QI3+PY8uyPOU55eMG1Dys9xFkifEA1Lc5/TbhTzSXTQINIOJT1cVI+nNeLlNcdB2luZsbIEL1PkKa7zO6rYqGcTvYOkL2d9H5Os94+wiHCCxmtP0a4jZ71jNU/4mHhpObEhj0cGDX0+GAVtxqp+DXCFF8QTSeiVHHZLg3xmK79VvJKgnCQOMpkYYBzWkhP10xu+LqHBX0m1xOv4ndWUeF5jxNn3tTd70XaAq8wDh0MGgyaDUhQEEUEYZiwUECGPBoxNLJyPyOrBhuTezJ1JGq7dGJEsUF7Ntw9t1Gk3Tz+KCJxlEO1CJL8Qf4qr8lP5Xn5y1yw2Fb3lK2bmrry4DvF5Zm5Gh7X08jjc01efJXUdpNXR5aseXq8muwaP+xXlzHmgjWPxHOw+/EtX5XMlymMFMXjVfPqS4R1WjE3359sfzs94i7PLrXWc62JizdWm5dn/WpI++6qvJPmVflPXvXx/GfNxGPiKTEmdornIYmXxS7xkthLqwviYG3HCJ2VhinSbZH6JNVgYJq89S9dP1t4vUZ/DPVRlBnM0lSJ93/CKmQ0nbkOb/qP28f8F+T3iuefKAIvbODImbptU3HvEKFlpW5zrgIXv9F98LZua6N+OPwEWDyrFq1SNZ8gvAEcdod6HugpmNOWls05Uocsn5O66cpiUsxQ20NSUtcl12VLFrOZVWLpdtiZ0x1uHKE5QvfEp0plk/qv8RGw/bBS+fmsUtl+ThrWgZf6b8C8/UXAeIuJAAAACXBIWXMAAAsTAAALEwEAmpwYAAAARUlEQVQ4EWP8//8/A2WABaidkRHdjP//oUKMjIQtYELXTTp/1AhEmDGCIxUjShAKCLMGR3BCkhZ6+hlNWoTjD6sKKkQqAEwMDSGRs5xiAAAAAElFTkSuQmCC";
                                        //alert("crap.gif: length of Swedish flag = "+asGIF.length);

                                }
                                else {
                                        alert("Could not parse DICOM file to extract pixel information or is not a supported image type");
                                }
                        }
                        else {
                                alert("Not a DICOM file - missing DICM magic number");
                        }
                        }
                else {
                        alert("Retrieved DICOM file is zero length or not found");
                }
        }
        else {
                alert("Could not retrieve DICOM file");
        }
        return asGIF;
}

  </script>

  </head>
  <body>
    <p>
      <img id="target" src="" width="100%">
      <script type="text/javascript">
        var my_gif = loadTestFile();
        document.getElementById("target").src=(my_gif);
      </script>
    </p>

<pre>Some MR defaults
                W   L
T1 - Axial     700 300
T1 - Sagittal  700 300
T1 - Coronal   700 300
T2 - Axial     475 155
T2 - Sagittal  475 155
T2 - Coronal   475 155
PD - Axial     920 420
PD - Sagittal  920 420
PD - Coronal   920 420

CT studies
Label   W   L
BONE  2000 500
SOFT   350  50
</pre>
<script type="text/javascript" src="http://code.jquery.com/jquery.min.js"></script>
<script type="text/javascript" src="http://code.jquery.com/mobile/latest/jquery.mobile.min.js"></script>

<script>
$('pre').on('tap', function(event){
  alert('You tapped an element');
});

$('img').on('swipe', function(event){
  alert('You swiped an image');
});

/* $('img').on('scrollstart', function(event){
  alert('You scrolled, you lucky you');
});
*/
</script>
</body>
</html>
