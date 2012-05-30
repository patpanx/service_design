# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

########
# card gestures
# ©2012 fabian troxler @ zhdk.ch
#
#
########

window.scripts = () ->
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
  card.click (e) ->
    t = $(e.originalEvent.target)
    #console.log t
    unless t.is 'textarea'
      card.toggleClass 'rotated'
     
  #when finger touches
  $('.card_table').on "touchstart", (e) ->
    save_tempP(e)
  
  
  $('.card_set').on "touchstart", (e) ->
    card = $('.card_set.current') #gets the top card in the "visible" stack - not equal to the top card-<Div>
    #console.log "card before:" + card
    prevCard = card.prev() #gets also the last card in the stack
    if prevCard.length == 0 #when the first card of the <div>'s is the top card, then there is no previous card
      prevCard = cardSets.last() # so take the last card
    
  $('a.section').on "touchstart", (e) ->
    section = $('.card .section') #gets the top card in the "visible" stack - not equal to the top card-<Div>
    #console.log "card before:" + card
    console.log "section"
  # when the finger is moved
  $('.card_table').on "touchmove", (e) ->
    e.preventDefault()
    
  $('.card_set').on "touchmove", (e) ->
    #prevent default actions like scrolling
    e.preventDefault()
    move_all(e,"")
  
  $('.new_card').on "touchmove", (e) ->
    e.preventDefault()
    new_card_up(e,$(this))
  
  $('a .card .section').on "touchmove", (e) ->
    #prevent default actions like scrolling
    e.preventDefault()
    move_section(e)
  
  $('.card_set').on "touchend touchcancel", (e) ->
    #console.log "touchend gesture: " + gesture
    
    touch_end(e)
    update_order()
  
  $('.new_card').on "touchend touchcancel", (e) ->
    $(this).animate {left:25, top:-30}, 200, () ->
      touch_end(e,$(this))
      
  $('.card.section').on "touchend touchcancel", (e) ->
    touch_end(e)
    update_section()     
  #mouse stuff -----------------------------
  #
  #
  
  $('.card_table').on "mousedown", (e) ->
    
    save_tempP(e)
  
  $('.card_set').on "mousedown", (e) ->
    mouseIsDown = 1
    card = $('.card_set.current') #gets the top card in the "visible" stack - not equal to the top card-<Div>
    prevCard = card.prev() #gets also the last card in the stack
    if prevCard.length == 0 #when the first card of the <div>'s is the top card, then there is no previous card
      prevCard = cardSets.last() # so take the last card
  
  $('.card .section').on "mousedown", (e) ->
    mouseIsDown = 1
    section = $('.card .section') #gets the top card in the "visible" stack - not equal to the top card-<Div>
    
  # when the finger is moved
  $('.card_set').on "mousemove", (e) ->
    #prevent default actions like scrolling
    e.preventDefault()
    if mouseIsDown
      move_all(e)
          
  $('.new_card'). on "mousemove", (e) ->
    #on touchend reset newCardPosition
    if mouseIsDown
      new_card_up(e,$(this))
  
  $('.card .section').on "mousemove", (e) ->
    #prevent default actions like scrolling
    e.preventDefault()
    move_section(e)
  
                  
  $('.card_set').on "mouseup", (e) ->
    touch_end(e,$(this))
    update_order()
  
  $('.new_card').on "mouseup", (e) ->
    #on touchend reset newCardPosition
    $(this).animate {left:25, top:-30}, 200, () ->
      touch_end(e,$(this))

  $('.card.section').on "mouseup", (e) ->
    touch_end(e)
    update_section()
  
    
  
  #functions ==================
  #
  #
  
  swipe = (touch,gesture) ->
    
    #console.log "hey gesture: " + gesture
    if gesture == "left"
      next_card()
    else if gesture == "right"
      previous_card()
    else if gesture == "up"
      
      send_card()
    else if gesture == "down"
      go_back()
    else if gesture == "new_card"
      new_card()
      console.log "new_card"
    else
    gesture = ""
  
  #next_card function
  next_card = () ->
    $('.card_set').css "z-index", "+=1"           #move all cards one step upwards
    actual = $('.card_set.current')               # save the current "top-card"
    actual.removeClass "current rotated"                 
    actual.css "z-index", 101-cardSets.length     # move the top card to the bottom
    cardSet = actual.next()                       #make the next card the top card
    #console.log cardSet.length
    if cardSet.length == 0                        #if there is no next card (because there is no next <div>-element)
      cardSet = cardSets.first()  
    cardSet.addClass "current"      
    #update_order()              
    
  #previous_card function - almost the same as nex_card, exept it takes the prevCard
  previous_card = () ->
    $('.card_set').css "z-index", "-=1"
    actual = $('.card_set.current')
    actual.removeClass "current"
    prevCard.css "z-index", 100  
    prevCard.addClass "current"

  send_card = () ->
    console.log "send_card"
    $('.current .submittable').parents('form:first').submit();
    card.animate {top: -500, opacity: 0}, 500, ->
      card.remove()
    
    
    $('.card_set').css "z-index", "+=1"           #move all cards one step upwards
    actual = $('.card_set.current')
    if actual == 0
       make_top_current()
       actual = $('.card_set.current')                  # save the current "top-card"
    actual.removeClass "current"            
        # move the top card to the bottom
    cardSet = actual.next()                       #make the next card the top card
                       
    #console.log cardSet.length
    if cardSet.length == 0                        #if there is no next card (because there is no next <div>-element)
      cardSet = cardSets.first()  
    #update_order()
    
  update_order = () ->
    console.log "update"
    $('.card_set').not('.new').each ->
      tCard = $(this) #tempcard
      id = tCard.css "z-index" #gets the z-index => "visible" order of the cards
      tCard.animate {left: (100-id)*5, top:-(100-id)*5}, 400 #card animation + stack animation
      
  update_section = () ->
    console.log "update"
    $('.card_set').each ->
      tCard = $(this) #tempcard
      id = tCard.css "z-index" #gets the z-index => "visible" order of the cards
      tCard.animate {left: (100-id)*5, top:-(100-id)*5}, 200 #card animation + stack animation
  
  make_top_current = () ->
    $('.card_set').each ->
      tCard = $(this) #tempcard
      id = tCard.css "z-index" #gets the z-index => "visible" order of the cards
      #console.log 'z-index ' + id
      if id == "100"
        
        console.log "found"
        cardSet = tCard
        cardSet.addClass "current"    
      
  new_card = () ->
    #$('.card_table').animate {opacity:0.3}, 200
    $('.card_set.current').removeClass 'current'

    $.ajax(
      type: "get"
      url: "/sessions/new"
    ).done (html) ->
      $('.card_table_center').append html
      $('.card_set.current').on "touchmove", (e) ->
        card = $(this)
        #prevent default actions like scrolling
        e.preventDefault()
        move_all(e,"onlySend")
      $('.card_set').on "touchend touchcancel", (e) ->
        touch_end(e)
        update_order()
      $('.card_set.current').on "mousemove", (e) ->
        if mouseIsDown
          card = $(this)
          #prevent default actions like scrolling
          e.preventDefault()
          move_all(e,"onlySend")
      $('.card_set').on "mouseup", (e) ->
        mouseIsDown = 0
        touch_end(e)
        update_order()
        
        
  go_back = () ->
    $('.card_set').animate {top:500,opacity:0},500, () ->
      window.location.href = "/";
  # gesture functions ---------------
  #
  #
  
  save_tempP = (e) ->
    # bugfix because jquery has problems with eventhandler
    touch = event
    mouseIsDown = 1
    #save current touchEventPosition
    tempTouchX = touch.pageX
    tempTouchY = touch.pageY
  
  move_all = (e,actions) ->

    touch = event
    #console.log "gesture: " + gesture
    #the distance the finger has moved
    unless actions is "onlySend"
      offsetX = touch.pageX - tempTouchX
    
    offsetY = touch.pageY - tempTouchY
    
    #allows the card only to move left/right or top/down
    if offsetY <= -minOffset && !gesture or offsetY >= minOffset && !gesture
      
      gesture = "topdown"
      
    else if offsetX <= -minOffset && !gesture or offsetX >= minOffset && !gesture
      gesture = "leftright"
    
     
    if gesture is "topdown" or gesture is "up" or gesture is "down"
      #console.log "if i was..."
      unless actions == "onlySend"
        if offsetY > 0
          $('.card_set').css("top", +offsetY - 25)
        else
          card.css("top", +offsetY - 25)
      else
        card.css("top", +offsetY - 25)

     else if gesture is "leftright" or gesture is "right" or gesture is "left"
        if offsetX < 0 #when the movement is to the right
          card.css("left", +offsetX) 
        else 
          
          prevCard.css("left", +offsetX)
    
    #detects the direction
    if offsetX <= -maxOffset && gesture is "leftright"
      gesture = "left"
      
      
  
    else if offsetX >= maxOffset && gesture is "leftright"
      gesture = "right"
      
      
    else if offsetY <= -maxOffset && gesture is "topdown"
      gesture = "up"
      #console.log gesture
      
    else if offsetY >= maxOffset && gesture is "topdown"
      
      unless actions == "onlySend"
        gesture = "down"
      else
        #console.log "remove new card"
        card.animate {top:500}, 500, () ->
          card.remove()
          make_top_current()
                            

  new_card_up = (e,newCard) ->
    
    #prevent default actions like scrolling
    # aigain stupid eventhandler bugfix
    touch = event
    
    #the distance the finger has moved
    offsetY = touch.pageY - tempTouchY
    
    #allows the card only to move left/right or top/down
    if offsetY <= -minOffset && !gesture
      gesture = "topdown"
      
    if gesture is "topdown" or "top"
      if offsetY <= 0 # new cardmoves only upwards
        newCard.css("top", +offsetY - 25)  

    #detects the direction
    if offsetY <= -maxOffset && gesture  == "topdown"
      gesture = "new_card"
      #swipe(touch, "new_card")
      
  touch_end = (e) ->
    swipe(e, gesture)
    gesture = ""    
    mouseIsDown = 0
    
  move_section = (e) ->
    console.log "mousemove"
    touch = event
    #console.log "gesture: " + gesture
    #the distance the finger has moved
    
    offsetX = touch.pageX - tempTouchX
    
    
    #allows the card only to move left/right or top/down
    if offsetY <= -minOffset && !gesture or offsetY >= minOffset && !gesture
      gesture = "topdown"
      
    else if offsetX <= -minOffset && !gesture or offsetX >= minOffset && !gesture
      gesture = "leftright"
    
     
    if gesture is "topdown" or gesture is "up" or gesture is "down"
      #console.log "if i was..."
      if offsetY <= -maxOffset
        offsetY = 0
      section.css("top", +offsetY - 25)
      

    else if gesture is "leftright" or gesture is "right" or gesture is "left"
        
      section.css("left", +offsetX) 
    
    #detects the direction
    if offsetX <= -maxOffset && gesture is "leftright"
      gesture = "turnleft"
      
      
  
    else if offsetX >= maxOffset && gesture is "leftright"
      gesture = "turnright"
      
      
    else if offsetY <= -maxOffset && gesture is "topdown"
      gesture = "nothing"
      #console.log gesture
      
    else if offsetY >= maxOffset && gesture is "topdown"
      
      gesture = "logout"
      
    