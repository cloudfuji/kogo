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

// Look into this later. The output has to match ruby's CGI.escape_html output.
  String.prototype.htmlEncode = function () {
    var i = this.length,
    aRet = [];

    while (i--) {
      var iC = this[i].charCodeAt();
      if (iC < 65 || iC > 127 || (iC>90 && iC<97)) {
        aRet[i] = '&#'+iC+';';
      } else {
        aRet[i] = this[i];
      }
    }
    return aRet.join('');    
  }
