# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  
  $('#position_toggle').click (e) ->
    $positions = $('div.positions')
    if $(this).text() == 'Show Positions'
      $positions.slideDown()
      $(this).text('Hide Positions')
    else
      $positions.slideUp()
      $(this).text('Show Positions')
    e.preventDefault()
    
  $('#session_toggle').click (e) ->
    $sessions = $('div.sessions')
    if $(this).text() == 'Show Sessions'
      $sessions.slideDown()
      $(this).text('Hide Sessions')
    else
      $sessions.slideUp()
      $(this).text('Show Sessions')
    e.preventDefault()
  