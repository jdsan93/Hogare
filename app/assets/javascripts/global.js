$( document ).on('turbolinks:load', function() {
    $('#multidatespicker').multiDatesPicker({
      minDate: 2,
      maxDate: 180,
      maxPicks: 30,
      beforeShowDay: function(date) {
        if (date.getDay() === 0) {return [false]; }
        return [true];
      }
    })
  })
