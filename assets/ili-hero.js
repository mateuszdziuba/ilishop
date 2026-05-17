(function () {
  var heroes = document.querySelectorAll('.ili-hero');

  heroes.forEach(function (hero) {
    var slides = hero.querySelector('.ili-hero__slides');
    var dots = hero.querySelectorAll('.ili-hero__dot');
    var prevBtn = hero.querySelector('.ili-hero__arrow--prev');
    var nextBtn = hero.querySelector('.ili-hero__arrow--next');
    var total = dots.length;
    var current = 0;
    var timer;
    var autoplay = hero.dataset.autoplay !== 'false';
    var speed = parseInt(hero.dataset.autoplaySpeed, 10) || 5000;
    var touchStartX = 0;
    var touchEndX = 0;

    if (total < 2) return;

    function goTo(n) {
      current = ((n % total) + total) % total;
      slides.style.transform = 'translateX(-' + (current * 100) + '%)';
      dots.forEach(function (d, i) {
        d.classList.toggle('active', i === current);
        d.setAttribute('aria-selected', i === current ? 'true' : 'false');
      });
    }

    function start() {
      if (!autoplay) return;
      timer = setInterval(function () { goTo(current + 1); }, speed);
    }

    function reset() {
      clearInterval(timer);
      start();
    }

    dots.forEach(function (d) {
      d.addEventListener('click', function () {
        goTo(+d.dataset.index);
        reset();
      });
    });

    if (prevBtn) {
      prevBtn.addEventListener('click', function () { goTo(current - 1); reset(); });
    }
    if (nextBtn) {
      nextBtn.addEventListener('click', function () { goTo(current + 1); reset(); });
    }

    /* Keyboard arrow navigation */
    hero.addEventListener('keydown', function (e) {
      if (e.key === 'ArrowLeft') { goTo(current - 1); reset(); }
      if (e.key === 'ArrowRight') { goTo(current + 1); reset(); }
    });

    /* Swipe / touch support */
    slides.addEventListener('touchstart', function (e) {
      touchStartX = e.changedTouches[0].screenX;
    }, { passive: true });

    slides.addEventListener('touchend', function (e) {
      touchEndX = e.changedTouches[0].screenX;
      var diff = touchStartX - touchEndX;
      if (Math.abs(diff) > 50) {
        goTo(diff > 0 ? current + 1 : current - 1);
        reset();
      }
    }, { passive: true });

    /* Pause on hover */
    hero.addEventListener('mouseenter', function () { clearInterval(timer); });
    hero.addEventListener('mouseleave', function () { start(); });

    start();
  });
})();
