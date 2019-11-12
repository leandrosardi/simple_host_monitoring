require_relative './basehost'

module BlackStack
  
  class LocalHostHistory < Sequel::Model(:hosthistory)
    LocalHostHistory.dataset = LocalHostHistory.dataset.disable_insert_output
  
  end # class LocalHostHistory

end # module BlackStack
