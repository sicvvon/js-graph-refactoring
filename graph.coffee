class Graph
  constructor :(data, selector) ->
    @data = data
    @graph = d3.select(selector)
    @width = 1000
    @height = 500
    @margins =
      top: 20
      right: 20
      bottom: 20
      left: 50

    @xMin = d3.min(data, (d) -> d.x)
    @xMax = d3.max(data, (d) -> d.x)
    @yMin = d3.min(data, (d) -> d.y)
    @yMax = d3.max(data, (d) -> d.y)
    
    @_calculateRanges()
    
  _calculateRanges: ->
    @xRange = d3.scale.linear()
                .range([ @margins.left, @width - @margins.right])
                .domain([ @xMin, @xMax ])

    @yRange = d3.scale.linear()
                .range([ @height - @margins.top, @margins.bottom ])
                .domain([ @yMin, @yMax ])
    
    
  _renderX: ->
    xAxis = d3.svg.axis().scale(@xRange)
              .tickSize(5).tickSubdivide(true)
    @graph
      .append('svg:g')
      .attr('class', 'x axis')
      .attr('transform', "translate(0, #{(@height - @margins.bottom)})")
      .call xAxis
    
  _renderY: ->
    yAxis = d3.svg.axis().scale(@yRange)
              .tickSize(5).orient('left').tickSubdivide(true)
    @graph
      .append('svg:g')
      .attr('class', 'y axis')
      .attr('transform', "translate(#{@margins.left}, 0)")
      .call yAxis

  renderData:(xRange, yRange) ->
    lineDrawer = d3.svg.line()
      .x( (d) -> xRange d.x )
      .y( (d) -> yRange d.y )
      .interpolate('basis')
    
    @graph
      .append('svg:path')
      .attr('d', lineDrawer(@data))
      .attr('stroke', 'blue')
      .attr('stroke-width', 2)
      .attr 'fill', 'none'
    
  render: ->
    @renderX()
    @renderY()
    @renderData(@xRange, @yRange)
    

window.Graph = Graph
