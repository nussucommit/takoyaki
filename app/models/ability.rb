# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Availability
    cannot :place, Availability
    cannot :show_everyone, Availability

    can :manage, User, id: user.id
    cannot %i[allocate_roles destroy], User, id: user.id
    cannot %i[show_full create set_roles], User

    user.roles.each { |role| __send__(role.name.downcase) }
  end

  def admin
    can :manage, :all
  end
end
