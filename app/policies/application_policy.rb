class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    only_admin
  end

  def new?
    create?
  end

  def update?
    only_admin
  end

  def edit?
    update?
  end

  def destroy?
    only_admin
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def permitted_for?(field, operation)
    permitted?(field) && send("#{operation}?")
  end

  def permitted?(field)
    permitted_attributes.values.first.include? field
  end

  protected
  def only_admin
    user.try(:admin?) || false
  end

  def done_by_onwer_or_admin?
    is_owned_by?(user) || user.try(:admin?)
  end

  def is_owned_by?(user)
    user.present? && record.user == user
  end
end

