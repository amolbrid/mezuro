class DateModuleResult < KalibroGem::Entities::DateModuleResult
  include KalibroRecord

  def module_result
    ModuleResult.new @module_result.to_hash
  end

end