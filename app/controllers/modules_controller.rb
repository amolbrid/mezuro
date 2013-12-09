class ModulesController < ApplicationController

  # GET /modules/1/metric_history
  # This should get the metric history of a given metric from the given module result 
  # and return its graphic
  def metric_history
   
  end

  # POST /modules/1/tree
  def load_module_tree
    @root_module_result = ModuleResult.find(params[:id].to_i)
  end

  private

  # This should use Gruff gem to generate the graphic using an array with values of
  # a given metric result and another array with its processed date.
  def graphic_for(values, dates)
    
  end

end