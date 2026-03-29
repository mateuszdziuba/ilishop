(function () {
  var heroes = document.querySelectorAll('.ili-hero')

  heroes.forEach(function (hero) {
    var slides = hero.querySelector('.ili-hero__slides')
    var dots = hero.querySelectorAll('.ili-hero__dot')
    var total = dots.length
    var current = 0
    var timer

    if (total < 2) return

    function goTo(n) {
      current = ((n % total) + total) % total
      slides.style.transform = 'translateX(-' + (current * 100) + '%)'
      dots.forEach(function (d, i) {
        d.classList.toggle('active', i === current)
      })
    }

    function start() {
      timer = setInterval(function () {
        goTo(current + 1)
      }, 5000)
    }

    function reset() {
      clearInterval(timer)
      start()
    }

    dots.forEach(function (d) {
      d.addEventListener('click', function () {
        goTo(+d.dataset.index)
        reset()
      })
    })

    start()
  })
})()
