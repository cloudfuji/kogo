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
