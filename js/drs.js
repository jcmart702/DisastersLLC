// cash is an smaller alternative to jQuery.
// A few catches:
//
// - Can't use Cash element as context, i.e., can't do $("child", $parent).
//   Use $parent.find("child") instead.
// - Can't trigger native events yet. Use native function, i.e. [0].focus().
cash(function() {
  var $document = $(document);
  var $header = $(".site-header");
  // $("body").on("change", "#searching, #primary-nav-toggle", function() {
  //   if(this.checked) {
  //     setTimeout(function() {
  //       $header.find("input[name=\"q\"]")[0].focus();
  //     }, 300);
  //   }
  // });

  if (window.matchMedia) {
    if (window.matchMedia('screen and (max-width: 767px)').matches) {
      var $anchor = $('.secondary-nav');
      $anchor.each(function(index, elem) {
        $(index).prev().on('click', function(e) {
          e.preventDefault();
          $(this).next().parent().toggleClass("mobile-active");
        });
      });
    }
  }

  var supportsVideo = !!document.createElement('video').canPlayType;

  /**
   * Play/pause a <video> element.
   *
   * @param {Element} video
   * @returns {bool} whether the video will be playing.
   */
  function toggleVideo(video) {
    var playing = (video.paused || video.ended);

    if (playing) {
      video.play();
    } else {
      video.pause();
    }
    return playing;
  }

  function stopVideo(event) {
    var $dialog = $(event.target);
    var $video = $dialog.find("video");
    if ($video.length) {
      var video = $video[0];
      video.pause();
      video.currentTime = 0;
    }
  }

  $(".video-container").each(function() {
    var $container = $(this);
    var playing = false;

    if (supportsVideo) {
      var video = $container.find("video")[0];
      video.controls = false;
    } else {
      // The browser should display fallback content.
      // We only handle case where the fallback content is placed inside a <noscript>,
      // i.e., embedded YouTube video. In those case, we just unwrap the <noscript>.
      var $fallback = $container.find("video noscript");
      $fallback.after($fallback.text());
      $fallback.remove();
    }
  });

  // Find the matching video from a button's href and launch modal.
  $document.on("click", "a[href*=\".mp4\"]", function(event) {
    var $button = $(this);
    var url = $button.attr("href");

    var $video = $("video source[src=\"" + url + "\"]").parent();
    var $dialog = $video.closest("dialog");

    if ($dialog.length) {
      $dialog[0].showModal();
    }

    if ($video.length) {
      event.preventDefault();
      toggleVideo($video[0]);
    }
  });

  // Handle dialog's events to stop video and close it.
  $("dialog")
    .on("cancel", stopVideo)
    .on("close", stopVideo)
    .on("click", function(event) {
      var dialog = event.target;
      var rect = dialog.getBoundingClientRect();
      var isInDialog=(rect.top <= event.clientY && event.clientY <= rect.top + rect.height
        && rect.left <= event.clientX && event.clientX <= rect.left + rect.width);
      if (!isInDialog) {
        dialog.close();
      }
    })
    .on("click", ".close", function(event) {
      $(event.target).closest("dialog")[0].close();
    });

  var $videos = $("video");
  $videos.on("playing", function(event) {
    var video = event.target;
    video.controls = true;
    $(video).closest(".video-container").toggleClass("playing", true);
  }).on("pause", function(event) {
    var video = event.target;
    // video.controls = false;
    $(video).closest(".video-container").toggleClass("playing", false);
  });
});
