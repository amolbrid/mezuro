class ModulesController < ApplicationController
  # GET /modules/1/metric_history
  def metric_history
    module_result = ModuleResult.new({ id: params[:id] })
    metric_history = module_result.metric_history(params[:metric_name]) # pending: sort this hash.
    dates = Array.new
    values = Array.new
    metric_history.keys.each do |date| 
      dates.push date
      values.push metric_history[date]
    end
    
    send_data(Base64.encode64(graphic_for(values, dates)), type: 'image/png', filename: "#{params[:module_id]}-#{params[:metric_name]}.png")
  end

  # POST /modules/1/tree
  def load_module_tree
    @root_module_result = ModuleResult.find(params[:id].to_i)
  end

  private

  def graphic_for(values, dates)
    graphic = Gruff::Line.new(400)
    graphic.hide_title = true
    graphic.hide_legend = true
    graphic.theme = {
      colors: ['grey'],
      marker_color: 'black',
      background_colors: '#fff'
    }

    graphic.labels = Hash[dates.each_with_index.map{ |date, index| [index, date.strftime("%Y/%m/%d")]}]

    graphic.data('Values', values)

    graphic.to_blob
  end
end