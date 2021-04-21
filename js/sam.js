Object.defineProperty($AM, "grid", {
  get: function() { return $AM(".debug-grid").is(":visible")},
  set: function(toggle) {
    $AM(".debug-grid").toggle(toggle);
  }
});
