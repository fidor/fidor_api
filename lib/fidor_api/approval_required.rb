module FidorApi
  class ApprovalRequired < RuntimeError
    attr_reader :confirmable_action

    def initialize(confirmable_action)
      @confirmable_action = confirmable_action
    end
  end
end
