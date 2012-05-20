# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.getPosition = ->
  console.log 'hey'
  if navigator.geolocation
    # Get current position
    navigator.geolocation.getCurrentPosition(savePosition)
    console.log 'hey'
  

window.savePosition = (position) ->
  $.post('/positions/save', position)
  console.log(position)
