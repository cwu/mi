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

dist2 = (p1, p2) -> (p1[0] - p2[0]) * (p1[0] - p2[0]) + (p1[1] - p2[1]) * (p1[1] - p2[1])
sse = (point, ref) -> _.min(_.map(ref, (p) -> dist2(p, point)))

diff = (path, ref) ->
  sum = 0
  for point in path
    sum += sse(point, ref)
  return sum / path.length

$ ->
  context = $('#canvas')[0].getContext('2d')
  [mx, my] = [null, null]
  [lx, ly] = [null, null]
  $('#canvas').on 'mousedown', (evt) ->
    evt.preventDefault()
    [x, y] = getXY evt
    [mx, my] = [x, y]
    [lx, ly] = [x, y]
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
    dx = x - mx
    dy = y - my

    [mx, my] = [x, y]


    if $('#no-smoothening').is(':checked')
      nx = lx + dx
      ny = ly + dy

      context.lineTo nx, ny
      context.stroke()
      userPath.push [nx, ny]
      [lx, ly] = [nx, ny]
    else if $('#low-pass-smoothening').is(':checked')
      nx = lx + dx / 3
      ny = ly + dy / 3

      context.lineTo nx, ny
      context.stroke()
      userPath.push [nx, ny]
      [lx, ly] = [nx, ny]
    else
      console.log 'stuff'

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
