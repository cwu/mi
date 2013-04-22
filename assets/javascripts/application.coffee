painting = false
userPath = []

getXY = (evt) ->
  [ evt.pageX - evt.target.offsetLeft,
    evt.pageY - evt.target.offsetTop ]

trace = (context, path, colour) ->
  oldStyle = context.strokeStyle
  context.strokeStyle = colour
  context.beginPath()
  context.moveTo path[0][0], path[0][1]
  for [x, y] in path.slice(1)
    context.lineTo x, y
    context.stroke()
  context.strokeStyle = oldStyle

$ ->
  context = $('#canvas')[0].getContext('2d')
  $('#canvas').on 'mousedown', (evt) ->
    evt.preventDefault()
    [x, y] = getXY evt
    context.beginPath()
    context.moveTo x, y
    context.stroke()
    painting = true
    userPath.push [x, y]

  $('#canvas').on 'mouseup', ->
    painting = false

  $('#canvas').on 'mousemove', (evt) ->
    return unless painting
    [x, y] = getXY evt
    context.lineTo x, y
    context.stroke()
    userPath.push [x, y]

  $('#save').on 'click', (evt) ->
    evt.preventDefault()
    name = $('#save-path-name').val()
    return if name.length == 0

    $.ajax
      type: "POST",
      contentType: "application/json; charset=utf-8",
      url: "/paths/save",
      data: JSON.stringify { name: name, path: userPath }
      dataType: "json"

  $('#trace').on 'click', (evt) ->
    evt.preventDefault()
    name = $('#trace-path-name').val()
    return if name.length == 0

    $.ajax(
      type: "GET",
      contentType: "application/json; charset=utf-8",
      url: "/paths/#{ name }",
      dataType: "json"
    ).done( (data) ->
      trace context, data.path, '#FF00FF'
    )

