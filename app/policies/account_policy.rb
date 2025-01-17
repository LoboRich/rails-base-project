class AccountPolicy < ApplicationPolicy
    attr_reader :user, :record
  
    def initialize(user, record)
      @user = user
      @record = record
    end
  
    def index?
      [
        'admin'
      ].include?(user.role)
    end

    def new?
      [
        'admin'
      ].include?(user.role)
    end

    def actions?
      [
        'admin'
      ].include?(user.role)
    end
    
    class Scope
      attr_reader :user, :scope
  
      def initialize(user, scope)
        @user = user
        @scope = scope
      end
  
      def resolve
        scope.all
      end
    end
  end
  