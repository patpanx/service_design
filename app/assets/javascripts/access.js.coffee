# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  
  $('#login_toggle').click (e) ->
    $foto = $('div.login')
    if $(this).text() == 'Show Login'
      $foto.slideDown()
      $(this).text('Hide Login')
    else
      $foto.slideUp()
      $(this).text('Show Login')
    e.preventDefault()
  