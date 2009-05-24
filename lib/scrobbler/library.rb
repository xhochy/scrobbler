module Scrobbler
  # @todo everything
  class Library < Base
    attr_reader :user
  
    def initialize(user)
      @user = user if user.class == Scrobbler::User
      @user = Scrobbler::User.new(user.to_s) unless user.class == Scrobbler::User
    end
    
  end
end

