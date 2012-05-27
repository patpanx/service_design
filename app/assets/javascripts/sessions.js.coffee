# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

########
# card gestures
# ©2012 fabian troxler @ zhdk.ch
#
#
########

$(document).ready ->
  minOffset = 20 # min offset Value for direction detection
  maxOffset = 200 # max offset Value - triggers the action (like send, nextcard etc)
  valX = 0
  valY = 0
  tempTouchX = 0
  tempTouchY = 0
  gesture = false
  card =
  
  #when finger touches
  $('.card, .active').on "touchstart", (e) ->
    card = $(this)
    # bugfix because jquery has problems with eventhandler
    touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0]
    
    #save current position of the card
    valX = touch.pageX - $(this).offset().left
    valY = touch.pageY - $(this).offset().top
    
    #save current touchEventPosition
    tempTouchX = touch.pageX
    tempTouchY = touch.pageY
  
  # when the finger is moved
  card.on "touchmove", (e) ->
    
    #prevent default actions like scrolling
    e.preventDefault()
    # aigain stupid eventhandler bugfix
    touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0]
    
    #the distance the finger has moved
    offsetX = touch.pageX - tempTouchX
    offsetY = touch.pageY - tempTouchY
    
    #console.log offsetX + "/" + offsetY
    
    #detects the direction
    if offsetX <= -maxOffset && gesture is "leftright"
      gesture = "left"
      swipe(touch, gesture)
      
  
    else if offsetX >= maxOffset && gesture is "leftright"
      gesture = "right"
      swipe(touch, gesture)
      
    
    else if offsetY <= -maxOffset && gesture is "topdown"
      gesture = "up"
      swipe(touch, gesture)
      
     
    else if offsetY >= maxOffset && gesture is "topdown"
      gesture = "down"
      swipe(touch, gesture)

    #get the card_table width 
    tableWidth = $(".card_table_center").parent().width()
    


    #allows the card only to move left/right or top/down
    if offsetY <= -minOffset && !gesture or offsetY >= minOffset && !gesture
      gesture = "topdown"
      
    else if offsetX <= -minOffset && !gesture or offsetX >= minOffset && !gesture
      gesture = "leftright"
    
    
    
    if gesture is "topdown" or gesture is "up" or gesture is "down"
      
      card.css("top",touch.pageY - valY - 25)

    else if gesture is "leftright" or gesture is "right" or gesture is "left"
    
      card.css("left", +offsetX)

  #on touchend reset cardPosition
  $(this).on "touchend", (e) ->
    gesture = false
    card.css("left",0)
    card.css("top",0)
    
  swipe = () ->
    console.log gesture
    
