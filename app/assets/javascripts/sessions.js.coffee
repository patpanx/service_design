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
  prevCard =
  cardSets = $('.card_set')
  mouseIsDown = 0
  
  
  #flip function
  $('.card_set').click ->
    card.toggleClass 'rotated'
     
  #when finger touches
  $('.card_set').on "touchstart", (e) ->
    card = $('.card_set.current')
    card.x = card.css "left"
    card.y = card.css "top"
    
    prevCard = card.prev()
    if prevCard.length == 0
      prevCard = cardSets.last()
    prevCard.x = prevCard.css "left"
    prevCard.y = prevCard.css "top"
    # bugfix because jquery has problems with eventhandler
    touch = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0]
    
    #save current position of the card
    valX = touch.pageX - $(this).offset().left
    valY = touch.pageY - $(this).offset().top
    
    #save current touchEventPosition
    tempTouchX = touch.pageX
    tempTouchY = touch.pageY
  
  # when the finger is moved
  $('.card_set').on "touchmove", (e) ->
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
        if offsetX < 0
          card.css("left", +offsetX)
        else 
          
          prevCard.css("left", +offsetX)
      
  #mouse stuff
  $('.card_set').on "mousedown", (e) ->
    card = $('.card_set.current')
    card.x = card.css "left"
    card.y = card.css "top"
    # bugfix because jquery has problems with eventhandler
    touch = event;
    mouseIsDown = 1
    #save current position of the card
    valX = touch.pageX - $(this).offset().left
    valY = touch.pageY - $(this).offset().top
    
    #save current touchEventPosition
    tempTouchX = touch.pageX
    tempTouchY = touch.pageY
  
  # when the finger is moved
  $('.card_set').on "mousemove", (e) ->
    #prevent default actions like scrolling
    e.preventDefault()
    if mouseIsDown
      # aigain stupid eventhandler bugfix
      touch = event;
      
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
        if offsetX < 0
          card.css("left", +offsetX)
        else 
          card = $('card_set.current').prev()
          card.css("left", +offsetX)
        
  $('.card_set').on "mouseup", (e) ->
    mouseIsDown = 0
    gesture = false
    $('.card_set').each ->
      tCard = $(this)
      id = tCard.css "z-index"
      tCard.animate {left: (100-id)*5, top:-(100-id)*5}, 200
      

  #on touchend reset cardPosition
  $('.card_set').on "touchend", (e) ->
    gesture = false
    
    $('.card_set').each ->
      tCard = $(this)
      id = tCard.css "z-index"
      tCard.animate {left: (100-id)*5, top:-(100-id)*5}, 200
      #tCard.css "left", (100-id)*5
      #tCard.css "top", -(100-id)*5
   # card.stop(true,true).animate {left: card.x,top:card.y}, 500
   # prevCard.stop(true,true).animate {left: prevCard.x,top:prevCard.y}, 500
    
    
  $('.card_set').on "touchcancel", (e) ->
    gesture = false
    $('.card_set').each ->
      tCard = $(this)
      id = tCard.css "z-index"
      tCard.animate {left: (100-id)*5, top:-(100-id)*5}, 200
    
  swipe = () ->
    console.log gesture
    
    if gesture == "left"
      next_card()
    else if gesture == "right"
      previous_card()
    else if gesture == "up"
    
    else if gesture == "down"
    
    else
    
  next_card = () ->
    $('.card_set').css "z-index", "+=1"
    actual = $('.card_set.current')
    actual.removeClass "current"
    actual.css "z-index", 101-cardSets.length 
    cardSet = actual.next()
    #console.log cardSet.length
    if cardSet.length == 0
      cardSet = cardSets.first()  
    cardSet.addClass "current"
    
  previous_card = () ->
    $('.card_set').css "z-index", "-=1"
    actual = $('.card_set.current')
    actual.removeClass "current"
    prevCard.css "z-index", 100  
    prevCard.addClass "current"

