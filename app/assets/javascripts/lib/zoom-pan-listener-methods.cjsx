module.exports =

  handleZoomPanViewBoxChange: (viewBox) ->
    console.log("In handle zoombox: new viewbox is " + viewBox)
    @setState viewBox: viewBox
