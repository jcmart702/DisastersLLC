if (window.svg4everybody) {
  svg4everybody();
}

if (dialogPolyfill) {
  var dialogs = document.querySelectorAll("dialog");
  var count = dialogs.length;
  while(count--) {
    var dialog = dialogs[count];
    dialogPolyfill.registerDialog(dialog);
  }
}
