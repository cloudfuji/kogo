/* Truncate 
   Takes the current string and returns a string of @len
   length where the last X characters (after truncation) are replaced
   with @ellipsis, if @len > (String.length + ellipsis)
*/
if (typeof String.prototype.truncate == undefined) {
  String.prototype.truncate = function (len, ellipsis) {
    if (ellipsis == undefined) ellipsis = '...';

    if (this.length > (len + ellipsis.length)) {
      return this.substring(0, (len - ellipsis.length)) + ellipsis;
    } else {
      return this;
    }
  };
}


String.prototype.startsWith = function (needle) {
  if (needle.length == 0) return false;

  return this.substring(0, (needle.length)) == needle;
}

String.prototype.endsWith = function (needle) {
  return this.substring((needle.length - 1), (this.length - 1)) == needle;
}

// Look into this later. The output has to match ruby's CGI.escape_html output.
//if (typeof String.prototype.rubyEscapeHtml == "undefined") {
String.prototype.rubyEscapeHtml = function () {
  var i = this.length,
  aRet = [];

  while (i--) {
    var iC = this[i].charCodeAt();
    if (iC == 62) {
      aRet[i] = '&gt;'
    } else if (iC == 60) {
      aRet[i] = '&lt;'
    } else if (iC == 38) {
      aRet[i] = '&amp;'
    } else if (iC == 34) {
      aRet[i] = '&quot;'
    } else {
      aRet[i] = this[i];
    }
  }
  return aRet.join('');    
}
//}
