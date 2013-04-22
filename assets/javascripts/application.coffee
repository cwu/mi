getXY = (evt) ->
  [ evt.pageX - evt.target.offsetLeft,
    evt.pageY - evt.target.offsetTop ]

$ ->
  context = $('#canvas')[0].getContext('2d')
  painting = false
  path = []
  $('#canvas').on 'mousedown', (evt) ->
    evt.preventDefault()
    [x, y] = getXY evt
    context.beginPath()
    context.moveTo x, y
    context.stroke()
    painting = true
    path.push [x, y]

  $('#canvas').on 'mouseup', -> painting = false

  $('#canvas').on 'mousemove', (evt) ->
    return unless painting
    [x, y] = getXY evt
    context.lineTo x, y
    context.stroke()
    path.push [x, y]
