# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, Availability
    cannot :place, Availability
    cannot :show_everyone, Availability

    can :manage, User, id: user.id
    cannot %i[create destroy allocate_roles update_roles show_full], User

    cannot :manage, Setting
    cannot :masquerade, User

    user.roles.each { |role| __send__(role.name.downcase) }
  end

  def admin
    can :manage, :all
  end
end
