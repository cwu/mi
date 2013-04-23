painting = false
userPath = []
retrievedPath = []

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

diff = (path1, path2) ->
  sse = (p1, p2) ->
    (p1[0] - p2[0]) * (p1[0] - p2[0]) + (p1[1] - p2[1]) * (p1[1] - p2[1])
  sum = 0
  i = 0
  while i < Math.min(path1.length, path2.length)
    p1 = path1[0]
    p2 = path2[0]
    sum += sse(p1, p2)
    i++
  return sum

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
      retrievedPath = data.path
    )

  $('#diff').on 'click', (evt) ->
    evt.preventDefault()

    $('#diff-display').text(diff(userPath, retrievedPath))
