// Generated by CoffeeScript 1.7.1
(function() {
  var DroppedASSFile;

  DroppedASSFile = (function() {
    function DroppedASSFile(fileBlob, cycleMessage, number, messages) {
      var fileReader, loadCallback, readyCallback;
      this.cycleMessage = cycleMessage;
      this.number = number;
      this.messages = messages;
      if (loadCallback === null) {
        loadCallback = function() {};
      }
      if (readyCallback === null) {
        readyCallback = function() {};
      }
      this.name = fileBlob.name;
      fileReader = new FileReader();
      fileReader.onloadend = (function(_this) {
        return function(e) {
          _this.cycleMessage("FINISHED " + _this.number);
          return _this.fixASSFile(e.target.result);
        };
      })(this);
      fileReader.readAsText(fileBlob);
    }

    DroppedASSFile.prototype.fixASSFile = function(fileString) {
      var extradataLines, lineEnding;
      extradataLines = [];
      lineEnding = fileString.match(/\r?\n/);
      fileString = fileString.replace(/[^\r\n]+/g, (function(_this) {
        return function(line) {
          if (line.match(/^\[Aegisub Extradata\]/) || line.match(/^Data:/)) {
            extradataLines.push(line);
            return '';
          } else {
            return line;
          }
        };
      })(this));
      fileString = fileString.replace(/[\r\n]{3,}/g, lineEnding);
      fileString += lineEnding + extradataLines.join(lineEnding);
      this.file = new Blob([fileString], {
        type: "text/plain;charset=utf-8"
      });
      this.size = fileString.length;
      return this.createElement();
    };

    DroppedASSFile.prototype.createElement = function() {
      var download, filecell, name;
      filecell = $("<div class='filecell'></div>");
      filecell.append(download = $("<div class='size'>DOWNLOAD</div>"));
      filecell.append(name = $("<div class='filename'>" + this.name + "</div>"));
      download.on('click', (function(_this) {
        return function(ev) {
          return saveAs(_this.file, _this.name);
        };
      })(this));
      $('#container').append(filecell);
      if (!this.messages.hasClass('gone')) {
        $('#shield').hide();
        this.messages.addClass('gone');
        return this.messages.bind('oanimationend animationend webkitAnimationEnd MSAnimationEnd', (function(_this) {
          return function() {
            return _this.messages.hide();
          };
        })(this));
      }
    };

    return DroppedASSFile;

  })();

  window.DroppedASSFile = DroppedASSFile;

}).call(this);