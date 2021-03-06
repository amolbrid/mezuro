class Module.Graphic
  constructor: (@container, @metric_name, @module_id) ->
    $('tr#'+@container).slideToggle('slow')
    this.load()

  load: ->
    # Those two var are necessary so the jQuery callback can use them
    # Otherwise the scope of the callback function is isolated
    container = @container 
    display = this.display

    $.get '/modules/' + @module_id + '/metric_history',
          metric_name: @metric_name
          (data) ->
            display(data,container)

  display: (data, container) ->
    $('div#'+container).html('<img id="' + container + '" src="data:image/png;base64,' + data + '" class="img-rounded"/>')